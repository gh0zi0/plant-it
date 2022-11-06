import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:plantit/components/e_button.dart';
import 'package:plantit/components/lottie_file.dart';
import 'package:plantit/screens/register_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.transparent, elevation: 0, actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      data['image'].toString().isEmpty
                          ? Icon(
                              Icons.person,
                              size: 100,
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  CachedNetworkImageProvider(data['image']),
                            ),
                      Container(
                          alignment: Alignment.center,
                          child: Text(
                            data['name'],
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                          alignment: Alignment.center,
                          child: Text(data['email'])),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 150,
                            height: 50,
                            child: Card(
                              color: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    LineIcons.tree,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  Text(data['plants'].toString())
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            height: 50,
                            child: Card(
                              color: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    LineIcons.coins,
                                    color: Colors.amberAccent,
                                    size: 30,
                                  ),
                                  Text(data['points'].toString())
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }
                return LottieFile(file: 'loading');
              },
            ),
            ListTile(
              leading: Icon(LineIcons.alternateTicket),
              title: Text('Vouchers'),
            ),
            ListTile(
              leading: Icon(LineIcons.hireahelper),
              title: Text('Get help'),
            ),
            ListTile(
              leading: Icon(LineIcons.questionCircle),
              title: Text('About app'),
            ),
            SizedBox(
              height: 20,
            ),
            EButton(
                title: 'Sign Out',
                function: () {
                  Get.off(() => RegisterScreen());
                  auth.signOut();
                },
                h: 50,
                w: 200)
          ],
        ),
      ),
    );
  }
}
