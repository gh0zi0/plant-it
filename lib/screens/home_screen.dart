import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/screens/register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(title: Text('home'),leading: IconButton(icon: Icon(Icons.power_settings_new),onPressed:() => Get.off(()=>RegisterScreen()),),),);
  }
}