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
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get(
          'https://flutter-firebase-project-4-default-rtdb.firebaseio.com/bucketlist.json');

      if (response.statusCode == 200) {
        bucketListData = response.data["heroes"];
        isLoading = false;
        setState(() {});
      }
    } catch (e) {
      isLoading = false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Can't connect to the server"),
            );
          });
    }
    // Show dialog for non-successful responses
    // Handle any exceptions that occur during the request
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            : ListView.builder(
                itemCount: bucketListData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
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
                  );
                }),
      ),
    );
  }
}
