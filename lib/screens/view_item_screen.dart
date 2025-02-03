import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ViewItem extends StatefulWidget {
  String name;
  String main_attribute;
  String short_description;
  String image_url;
  int index;
  ViewItem(
      {super.key,
      required this.name,
      required this.main_attribute,
      required this.image_url,
      required this.short_description,
      required this.index});

  @override
  State<ViewItem> createState() => _AddBucketListScreenState();
}

class _AddBucketListScreenState extends State<ViewItem> {
  Future<void> deleteData() async {
    Navigator.pop(context);
    try {
      // print("detele call");
      Response response = await Dio().delete(
          'https://flutter-firebase-project-4-default-rtdb.firebaseio.com/bucketlist/heroes/${widget.index}.json');
    } catch (e) {
      print("error");
    }
    Navigator.pop(context, "refresh");
  }

  Future<void> markAsComplete() async {
    try {
      Map<String, dynamic> data = {"completed": true};
      Response response = await Dio().patch(
          'https://flutter-firebase-project-4-default-rtdb.firebaseio.com/bucketlist/heroes/${widget.index}.json',
          data: data);
    } catch (e) {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(onSelected: (value) {
              if (value == 1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Are You sure to Delete"),
                        actions: [
                          InkWell(
                            onTap: () {
                              deleteData();
                            },
                            child: Text("Confirm"),
                          ),
                          Text("Cancel"),
                        ],
                      );
                    });
              }
              if (value == 2) {
                markAsComplete();
              }
            }, itemBuilder: (context) {
              return [
                PopupMenuItem(value: 1, child: Text("Delete")),
                PopupMenuItem(value: 2, child: Text("Mark as Complete"))
              ];
            })
          ],
          title: Text("${widget.name}"),
        ),
        body: Column(
          children: [
            Text(widget.index.toString()),
            Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.red,
                  image:
                      DecorationImage(image: NetworkImage(widget.image_url))),
            ),
            SizedBox(
              height: 100,
            ),
            Text(widget.short_description),
          ],
        ));
  }
}
