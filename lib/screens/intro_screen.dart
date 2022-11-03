import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/t_button.dart';
import 'package:plantit/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController controller = PageController();

  bool last = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            last = value == 2;
          });
        },
        controller: controller,
        children: [
          Container(
            height: double.infinity,
            child: Column(children: [
              Image.network(
                  'https://images.unsplash.com/photo-1458966480358-a0ac42de0a7a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fHRyZWVzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
              Text('dwqddqwdwdwdwwdw'),
              Text('dqwd')
            ]),
          ),
          Container(
            height: double.infinity,
            child: Column(children: [
              Image.network(
                  'https://images.unsplash.com/photo-1473448912268-2022ce9509d8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHRyZWVzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
              Text('dwqddqwdwddwqfqwfwdwwdw'),
              Text('dqwffasfd')
            ]),
          ),
          Container(
            height: double.infinity,
            child: Column(children: [
              Image.network(
                  'https://images.unsplash.com/photo-1513836279014-a89f7a76ae86?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fHRyZWVzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60'),
              Text('dwqddqwdwqfqwfdhyjudwdwwdw'),
              Text('dqwdswqdwqdwqdwq')
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                controller.previousPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeIn);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          SmoothPageIndicator(
            controller: controller,
            count: 3,
            onDotClicked: (index) {
              controller.animateToPage(index,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn);
            },
            effect: const WormEffect(
                spacing: 16,
                dotColor: Colors.black38,
                activeDotColor: Colors.green),
          ),
          last
              ? TButton(
                  title: 'Start',
                  function: () async {
                    final pref = await SharedPreferences.getInstance();
                    setState(() {
                      pref.setBool('intro', false);
                    });
                    Get.off(() => RegisterScreen());
                  },
                )
              : IconButton(
                  onPressed: () {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                  },
                  icon: const Icon(Icons.arrow_forward_ios))
        ],
      ),
    );
  }
}
