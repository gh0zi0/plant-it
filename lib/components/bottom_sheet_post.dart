import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  var content = TextEditingController(),
      loading = false,
      caption = tr('caption'),
      pleaseCaption = tr('pleaseCaption'),
      get = Get.put(Functions());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.isDarkMode ? const Color(0xFF424242) : Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: const EdgeInsets.all(10),
      child: Form(
        key: Gkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'newPost',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ).tr(),
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
                      width: MediaQuery.of(context).size.width / 1.15,
                      decoration: BoxDecoration(
                          image: get.file != null
                              ? DecorationImage(
                                  image: FileImage(get.file),
                                  fit: BoxFit.fitWidth)
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
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
              EditTextFiled(
                hint: caption,
                icon: Icons.text_fields_outlined,
                controller: content,
                secure: false,
                validator: (val) {
                  if (val!.isEmpty) return pleaseCaption;
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              loading
                  ? const CircularProgressIndicator()
                  : EButton(
                      color: const Color(0xFF009345),
                      title: 'post',
                      function: () {
                        setState(() {
                          loading = !loading;
                        });
                        get.sharePost(Gkey, context, content.text);
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
