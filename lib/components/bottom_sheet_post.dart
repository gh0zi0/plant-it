import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantit/components/lottie_file.dart';
import '../services/functions.dart';
import 'e_button.dart';
import 'edit_text.dart';

// ignore: must_be_immutable
class BottomSheetPost extends StatefulWidget {
  const BottomSheetPost({super.key});

  @override
  State<BottomSheetPost> createState() => _BottomSheetPostState();
}

class _BottomSheetPostState extends State<BottomSheetPost> {
  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> Gkey = GlobalKey();
  var title = TextEditingController(),
      content = TextEditingController(),
      image = TextEditingController(),
      focusT = FocusNode(),
      focusC = FocusNode(),
      focusI = FocusNode(),
      loading = false,
      get = Get.put(Functions());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.topCenter,
      height: double.infinity,
      child: Form(
        key: Gkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'New post',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              EditTextFiled(
                focus: focusC,
                hint: 'Post content',
                icon: Icons.text_fields_outlined,
                controller: content,
                secure: false,
                validator: (val) {
                  if (val!.isEmpty) return 'Please enter a post content';
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(children: [
                GestureDetector(
                    onTap: () async {
                      await get.getFromGallery();
                      setState(() {});
                    },
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width / 1.25,
                      decoration: BoxDecoration(
                          image: get.file != null
                              ? DecorationImage(
                                  image: FileImage(get.file),
                                  fit: BoxFit.fitWidth)
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1)),
                      child: get.file == null
                          ? const Icon(
                              Icons.photo,
                              size: 75,
                            )
                          : null,
                    )),
                if (get.imageFile != null)
                  IconButton(
                      onPressed: () {
                        get.deleteFile();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
              ]),
              const SizedBox(
                height: 25,
              ),
              loading
                  ? LottieFile(
                      file: 'loading',
                    )
                  : EButton(
                      color: Colors.green,
                      title: 'Share',
                      function: () {
                        setState(() {
                          loading = !loading;
                        });
                        get.sharPost(Gkey, context, content.text);
                      },
                      h: 50,
                      w: 150,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
