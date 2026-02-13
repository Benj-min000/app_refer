import 'package:flutter/material.dart';
import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/screens/address_screen.dart';
import 'package:user_app/screens/history_screen.dart';
import 'package:user_app/screens/my_orders_screen.dart';
import 'package:user_app/screens/search_screen.dart';
import 'package:user_app/screens/profile_settings_screen.dart';
import 'package:user_app/services/firebase_data_transfer.dart';

class DrawerItem {
  final String title;
  final IconData icon;
  final Widget screen;

  const DrawerItem({
    required this.title,
    required this.icon,
    required this.screen,
  });
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final List<DrawerItem> drawerItems = [
      DrawerItem(title: "Profile Settings", icon: Icons.manage_accounts, screen: const ProfileSettingsScreen()),
      DrawerItem(title: "My Orders", icon: Icons.reorder, screen: MyOrdersScreen()),
      DrawerItem(title: "History", icon: Icons.access_time, screen: const HistoryScreen()),
      DrawerItem(title: "Search", icon: Icons.search, screen: SearchScreen(initialText: "")),
      DrawerItem(title: "Address Manager", icon: Icons.location_on_outlined, screen: AddressScreen()),
    ];

    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photo")!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 20, fontFamily: "Train"),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          ...drawerItems.map((item) => Column(
            children: [
              const Divider(height: 1, thickness: 1, color: Colors.grey),
              ListTile(
                leading: Icon(item.icon, color: Colors.black),
                title: Text(item.title, style: const TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => item.screen));
                },
              ),
            ],
          )),

          const Divider(height: 1, thickness: 1, color: Colors.grey),

          ListTile(
            leading: Icon(Icons.data_array, color: Colors.black),
            title: Text("Firebase Export", style: const TextStyle(color: Colors.black)),
            onTap: () {
              FirestoreDumpTool.startExport();
            },
          ),

          const Divider(height: 1, thickness: 1, color: Colors.grey),

          ListTile(
            leading: Icon(Icons.data_usage, color: Colors.black),
            title: Text("Firebase Import", style: const TextStyle(color: Colors.black)),
            onTap: () {
              FirestoreDumpTool.startImport();
            },
          ),
            
          const Divider(height: 10, color: Colors.grey, thickness: 2),

          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            title: const Text(
              "Sign Out",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              firebaseAuth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AuthScreen()));
              });
            },
          ),
          const Divider(
            height: 10,
            color: Colors.grey,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
