import 'package:bucketlistapp/screens/add_bucket_list_screen.dart';
import 'package:bucketlistapp/screens/view_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketListData = [];

  bool isLoading = false;
  bool isError = false;
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          'https://flutter-firebase-project-4-default-rtdb.firebaseio.com/bucketlist.json');

      if (response.statusCode == 200) {
        // bucketListData = response.data["heroes"];
        // print(response.data);
        if (response.data is Map) {
          bucketListData = (response.data["heroes"] is List)
              ? response.data["heroes"]
              : [response.data['heroes']];
        } else {
          bucketListData = [];
        }

        isLoading = false;
        isError = false;
        setState(() {});
      }
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});
    }
    // Show dialog for non-successful responses
    // Handle any exceptions that occur during the request
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning),
          Text("Error getting the data"),
          ElevatedButton(onPressed: () {}, child: Text("Please try again"))
        ],
      ),
    );
  }

  Widget listViewWidget() {
    List<dynamic> filterList = bucketListData
        .where((element) => !(element?["completed"] ?? false))
        .toList();
    return filterList.length < 1
        ? Center(child: Text("No Data Available"))
        : ListView.builder(
            itemCount: bucketListData.length,
            itemBuilder: (BuildContext context, int index) {
              return (bucketListData[index] is Map &&
                      (!(bucketListData[index]?["completed"] ?? false)))
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewItem(
                                name: bucketListData[index]["name"] ?? "",
                                main_attribute: bucketListData[index]
                                        ["main_attribute"] ??
                                    "",
                                short_description: bucketListData[index]
                                        ["short_description"] ??
                                    "",
                                image_url:
                                    bucketListData[index]["image_url"] ?? "",
                                index: index);
                          })).then((value) {
                            if (value == "refresh") {
                              getData();
                            }
                          });
                        },
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              bucketListData[index]["image_url"] ?? ""),
                        ),
                        title: Text(bucketListData[index]["name"] ?? "NO NAME"),
                        trailing: Text(
                          bucketListData[index]["main_attribute"] ?? "",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  : SizedBox();
            });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddBucketListScreen(newIndex: bucketListData.length);
          })).then((value) {
            if (value == "refresh") {
              getData();
            }
          });
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Bucket List App"),
        actions: [
          InkWell(
            onTap: getData,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getData();
        },
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : isError
                ? errorWidget()
                : listViewWidget(),
      ),
    );
  }
}
