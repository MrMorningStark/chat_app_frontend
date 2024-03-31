import 'package:WhatsApp/api/api.dart';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

bool isUserLoggedIn() {
  try {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    return false;
  } on Exception catch (_) {
    return false;
  }
}

Future<dynamic> signInWithGoogle(phoneNumber) async {
  try {
    // check if user is already signed in
    if (FirebaseAuth.instance.currentUser != null) {
      await signOutFromGoogle();
      return;
    }

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    MyUser user = MyUser(
        uid: userCredential.user?.uid ?? '',
        displayName: userCredential.user?.displayName ?? '',
        email: userCredential.user?.email ?? '',
        photoURL: userCredential.user?.photoURL ?? '',
        phoneNumber: phoneNumber);
        
    bool result = await API.save(
        collectionName: CollectionName.USERS, data: user.toJson());
    if (result) {
      Routes.navigateTo(
          route: Routes.HOME_PAGE, naviagteType: NavigateType.REPLACE);
    } else {
      signOutFromGoogle();
    }
  } on Exception catch (e) {
    Routes.navigateTo(
        route: Routes.WELCOME_PAGE, naviagteType: NavigateType.REPLACE);
    print('exception->$e');
  }
}

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Routes.navigateTo(
        route: Routes.WELCOME_PAGE, naviagteType: NavigateType.REPLACE);
    return true;
  } on Exception catch (_) {
    Routes.navigateTo(
        route: Routes.WELCOME_PAGE, naviagteType: NavigateType.REPLACE);
    return false;
  }
}
