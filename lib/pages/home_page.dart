import 'package:WhatsApp/auth/firebase.dart';
import 'package:WhatsApp/enumeration.dart';
import 'package:WhatsApp/components/RecentChats.dart';
import 'package:WhatsApp/pages/welcome_page.dart';
import 'package:WhatsApp/provider/socketProvider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 4, vsync: this);
  }

  showMenu(BuildContext context) {
    // show dialog where user pressed the button show menu
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  signOutFromGoogle();
                })
          ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    const double tabBarWidthIcon = 20;
    double tabBarWidthText =
        (MediaQuery.of(context).size.width / 3) - (tabBarWidthIcon * 2.45);

    if (isUserLoggedIn()) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('WhatsApp'),
          actions: [
            IconButton(
              onPressed: () {
                Routes.navigateTo(route: Routes.SEARCH_PAGE);
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                showMenu(context);
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorWeight: 3.0,
            tabAlignment: TabAlignment.start,
            tabs: <Widget>[
              const SizedBox(
                width: tabBarWidthIcon,
                child: Tab(
                  icon: Icon(
                    Icons.groups,
                    size: 26,
                  ),
                ),
              ),
              SizedBox(
                width: tabBarWidthText,
                child: const Tab(
                  text: 'Chats',
                ),
              ),
              SizedBox(
                width: tabBarWidthText,
                child: const Tab(
                  text: 'Updates',
                ),
              ),
              SizedBox(
                width: tabBarWidthText,
                child: const Tab(
                  text: 'Calls',
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/contacts');
          },
          child: const Icon(Icons.message),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            Center(
              child: Text("It's cloudy here"),
            ),
            RecentChats(),
            Center(
              child: Text("It's sunny here"),
            ),
            Center(
              child: Text("It's wow here"),
            ),
          ],
        ),
      );
    } else {
      return const WelcomePage();
    }
  }
}
