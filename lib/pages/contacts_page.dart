import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:WhatsApp/provider/mainProvider.dart';
import 'package:WhatsApp/widgets/contactCard.dart';
import 'package:WhatsApp/widgets/custom_elevated_button.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactsPage extends ConsumerWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localContacts = ref.watch(futureLocalContactsProvider);
    final contactsPermission = ref.watch(contactsPermissionProvider);
    return localContacts.when(
      data: (localContacts) => Contacts(
          contacts: localContacts, contactsPermission: contactsPermission),
      error: (err, stack) =>
          Scaffold(body: Center(child: Text(err.toString()))),
      loading: () => Contacts(
        contacts: const [],
        contactsPermission: contactsPermission,
      ),
    );
  }
}

class Contacts extends StatefulWidget {
  final List<MyUser> contacts;
  final bool contactsPermission;
  const Contacts(
      {super.key, required this.contacts, required this.contactsPermission});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  late List<MyUser> searchContacts = [];
  late bool contactsPermission;
  bool showSearchBar = false;

  @override
  void initState() {
    super.initState();
    searchContacts = widget.contacts;
    contactsPermission = widget.contactsPermission;
  }

  searchUsers(searchKey) {
    if (searchKey.isEmpty) {
      setState(() {
        searchContacts = widget.contacts;
      });
      return;
    }
    setState(() {
      searchContacts = widget.contacts
          .where((element) => element.displayName
              .toLowerCase()
              .contains(searchKey.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showSearchBar
          ? AppBar(
              title: TextField(
                autofocus: true,
                onChanged: searchUsers,
                decoration: const InputDecoration(
                    hintText: 'Search', border: InputBorder.none),
              ),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    showSearchBar = false;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
            )
          : AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Contact',
                    style: TextStyle(fontSize: 16, letterSpacing: 0),
                  ),
                  const SizedBox(height: 5),
                  Text("${widget.contacts.length} contacts",
                      style: const TextStyle(fontSize: 12, letterSpacing: 0))
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      showSearchBar = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
      body: !contactsPermission
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'WhatsApp needs access to your contacts to work properly',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomElevatedButton(
                    onPressed: () async {
                      await AppSettings.openAppSettings(
                          type: AppSettingsType.settings);
                      Routes.navigateTo(route: Routes.HOME_PAGE);
                    },
                    text: "Grant access",
                    buttonWidth: 200,
                  ),
                ],
              ),
            )
          : Scrollbar(
              interactive: true,
              thumbVisibility: true,
              thickness: 5,
              radius: const Radius.circular(10),              
              child: ListView.builder(
                itemCount: showSearchBar
                    ? searchContacts.length
                    : widget.contacts.length,
                itemBuilder: (context, i) => ContactCard(
                  user: showSearchBar ? searchContacts[i] : widget.contacts[i],
                  imgSize: 46,
                ),
              ),
            ),
    );
  }
}
