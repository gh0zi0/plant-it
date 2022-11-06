import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:plantit/components/e_button.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1667508640768-39063e822490?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyMjd8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Ghazi',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(alignment: Alignment.center, child: Text('g@g.com')),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            LineIcons.tree,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('2')
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            LineIcons.coins,
                            color: Colors.amberAccent,
                            size: 30,
                          ),
                          Text('200')
                        ],
                      ),
                    ),
                  )
                ],
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
              EButton(title: 'Sign Out', function: () {}, h: 50, w: 150)
            ],
          ),
        ),
      ),
    );
  }
}
