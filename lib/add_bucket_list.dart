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
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Bucket List"),
      ),
      body: Column(
        children: [
          TextField(
            controller: nameText,
            decoration: InputDecoration(label: Text("Name")),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: descriptionText,
            decoration: InputDecoration(label: Text("Description")),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: attributeText,
            decoration: InputDecoration(label: Text("Main Attribute")),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: imageURLText,
            decoration: InputDecoration(label: Text("Image URL")),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: addData, child: Text("Add Data"))),
            ],
          ),
        ],
      ),
    );
  }
}
