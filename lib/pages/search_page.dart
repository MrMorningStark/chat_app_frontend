import 'package:WhatsApp/api/api.dart';
import 'package:WhatsApp/models/basic_models.dart';
import 'package:WhatsApp/models/user_model.dart';
import 'package:WhatsApp/widgets/contactCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<MyUser> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // search function
    search(searchKey) async {
      if (searchKey.isEmpty) {
        setState(() {
          this.users = [];
        });
        return;
      }

      setState(() {
        isLoading = true;
      });
      ApiResponse apiResponse = await API.searchUser(searchKey: searchKey);

      if (apiResponse.success) {
        List<MyUser> users = apiResponse.data
            .map<MyUser>((json) => MyUser.fromJson(json))
            .toList();
        setState(() {
          this.users = users;
        });
      }
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        //  search bar
        title: TextField(
          controller: searchController,
          autofocus: true,
          onChanged: (value) {
            search(value);
          },
          decoration: const InputDecoration(
            hintText: 'Search contacts',
          ),
        ),
      ),
      body: users.isEmpty
          ? Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(searchController.text.isEmpty
                      ? 'Search for contacts'
                      : 'No results found'),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                MyUser user = users[index];
                return ContactCard(
                  photoURL: user.photoURL,
                  displayName: user.displayName,
                  caption: user.email,
                  user: user,
                );
              },
            ),
    );
  }
}
