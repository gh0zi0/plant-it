import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/intro_container.dart';
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

  bool last = false, first = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            first = value == 0;
            last = value == 2;
          });
        },
        controller: controller,
        children: [
          IntroContainer(image: 'plant', title: 'ازرع أشجار أكثر', content: ''),
          IntroContainer(
              image: 'water', title: 'اسقي الأشجار المزروعة', content: ''),
          IntroContainer(
              image: 'save', title: 'احمي الأرض من التلوث', content: '')
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          first
              ? const SizedBox(
                  width: 50,
                )
              : IconButton(
                  onPressed: () {
                    controller.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.green,
                  )),
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
                    Get.off(() => const RegisterScreen());
                  },
                )
              : IconButton(
                  onPressed: () {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                  },
                  icon:
                      const Icon(Icons.arrow_forward_ios, color: Colors.green))
        ],
      ),
    );
  }
}
