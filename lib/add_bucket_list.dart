import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBucketListScreen extends StatefulWidget {
  int newIndex;
  AddBucketListScreen({super.key, required this.newIndex});

  @override
  State<AddBucketListScreen> createState() => _AddBucketListScreenState();
}

class _AddBucketListScreenState extends State<AddBucketListScreen> {
  Future<void> addData() async {
    try {
      Map<String, dynamic> data = {
        "completed": false,
        "image_url":
            "https://static.wikia.nocookie.net/dota2_gamepedia/images/9/9d/Mars_icon.png/revision/latest?cb=20190401094550",
        "main_attribute": "Strength",
        "name": "Mars",
        "short_description":
            "Mars is a durable melee hero who excels in team fights with his crowd control abilities and powerful spear-based attacks."
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
      body: ElevatedButton(onPressed: addData, child: Text("Add Data")),
    );
  }
}
