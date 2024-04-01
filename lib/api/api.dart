import 'package:WhatsApp/constant.dart';
import 'package:WhatsApp/models/basic_models.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class API {
  static final dio = Dio();

  static Future<bool> save(
      {required String collectionName, required Map data}) async {
    try {
      var finalEndPoint = "${BASE_URL}data/save/$collectionName";
      var result = await dio.post(Uri.encodeFull(finalEndPoint), data: data);
      if (result.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<ApiResponse> searchUser({required String searchKey}) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      var finalEndPoint = "${BASE_URL}data/searchUser/$searchKey";
      var result = await dio.post(Uri.encodeFull(finalEndPoint),
          data: {"uid": user.uid.toString()});
      return ApiResponse.fromJson(result.data);
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }

  static Future<ApiResponse> usersExist(
      {required List<Map<String, dynamic>> users}) async {
    try {
      var finalEndPoint = "${BASE_URL}data/usersExist";
      var result =
          await dio.post(Uri.encodeFull(finalEndPoint), data: {"users": users});
      return ApiResponse.fromJson(result.data);
    } catch (e) {
      return ApiResponse(success: false, data: [], message: e.toString());
    }
  }

  static Future<ApiResponse> loadConversation(
      {required String conversationId}) async {
    try {
      var finalEndPoint = "${BASE_URL}data/loadConversation/$conversationId";
      var result = await dio.post(Uri.encodeFull(finalEndPoint));
      return ApiResponse.fromJson(result.data);
    } catch (e) {
      return ApiResponse(success: false, data: [], message: e.toString());
    }
  }

  static Future<ApiResponse> loadRecentChats() async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      var finalEndPoint = "${BASE_URL}data/loadRecentChats/${user.uid}";
      var result = await dio.post(Uri.encodeFull(finalEndPoint));
      return ApiResponse.fromJson(result.data);
    } catch (e) {
      return ApiResponse(success: false, data: [], message: e.toString());
    }
  }
}
