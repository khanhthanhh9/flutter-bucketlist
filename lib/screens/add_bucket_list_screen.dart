import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBucketListScreen extends StatefulWidget {
  int newIndex;
  AddBucketListScreen({super.key, required this.newIndex});

  @override
  State<AddBucketListScreen> createState() => _AddBucketListScreenState();
}

class _AddBucketListScreenState extends State<AddBucketListScreen> {
  TextEditingController nameText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
  TextEditingController attributeText = TextEditingController();
  TextEditingController imageURLText = TextEditingController();

  Future<void> addData() async {
    try {
      Map<String, dynamic> data = {
        "completed": false,
        "image_url": imageURLText.text,
        "main_attribute": attributeText.text,
        "name": nameText.text,
        "short_description": descriptionText.text
      };
      Response response = await Dio().patch(
          'https://flutter-firebase-project-4-default-rtdb.firebaseio.com/bucketlist/heroes/${widget.newIndex}.json',
          data: data);
      Navigator.pop(context, "refresh");
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var addForm = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Bucket List"),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: addForm,
        child: Column(
          children: [
            TextFormField(
              controller: nameText,
              decoration: InputDecoration(label: Text("Name")),
              validator: (value) {
                if (value.toString().length < 3) {
                  return "Must be more than 3 characters";
                }
                if (value == null || value.isEmpty) {
                  return "value must not be empty";
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                controller: descriptionText,
                decoration: InputDecoration(label: Text("Description")),
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Must be more than 3 characters";
                  }
                  if (value == null || value.isEmpty) {
                    return "value must not be empty";
                  }
                }),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: attributeText,
              decoration: InputDecoration(label: Text("Main Attribute")),
              validator: (value) {
                if (value.toString().length < 3) {
                  return "Must be more than 3 characters";
                }
                if (value == null || value.isEmpty) {
                  return "value must not be empty";
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                controller: imageURLText,
                decoration: InputDecoration(label: Text("Image URL")),
                validator: (value) {
                  if (value.toString().length < 3) {
                    return "Must be more than 3 characters";
                  }
                  if (value == null || value.isEmpty) {
                    return "value must not be empty";
                  }
                }),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          if (addForm.currentState!.validate()) {
                            addData();
                            // Successful
                          } else {
                            print("Error");
                          }
                        },
                        child: Text("Add Data"))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
