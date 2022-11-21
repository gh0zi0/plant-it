import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:plantit/services/firestore.dart';
import 'package:plantit/services/functions.dart';
import 'package:plantit/services/map_utils.dart';
import 'e_button.dart';
import 'edit_text.dart';

// ignore: must_be_immutable
class BottomSheetPlant extends StatefulWidget {
  BottomSheetPlant({super.key, required this.currentLocation});
  LocationData? currentLocation;

  @override
  State<BottomSheetPlant> createState() => _BottomSheetPlantState();
}

class _BottomSheetPlantState extends State<BottomSheetPlant> {
  // ignore: non_constant_identifier_names
  final GlobalKey<FormState> Gkey = GlobalKey();
  var content = TextEditingController(),
      loading = false,
      caption = tr('plantName'),
      pleaseCaption = tr('plantName'),
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
                'plantNewTree',
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
                      color: Colors.green,
                      title: 'plant',
                      function: () async {
                        setState(() {
                          loading = !loading;
                        });
                        var snap = await FireStoreServices().getData;
                        DateTime dateToday = DateTime.now();
                        await FireStoreServices().addTree(
                            FireStoreServices().getUserNmae(),
                            content.text,
                            "low",
                            dateToday,
                            GeoPoint(widget.currentLocation!.latitude!,
                                widget.currentLocation!.longitude!));

                        await FireStoreServices().updatePlant();
                        MapUtils().limitedPointDaily(snap);

                        content.clear();

                        Get.back();
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: const Text('Planted').tr()));
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
