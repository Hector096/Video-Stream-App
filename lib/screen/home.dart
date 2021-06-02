import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videostremapp/util/sizeConfig.dart';
import 'package:videostremapp/screen/videoPlayer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        elevation: 0,
        leading: Icon(Icons.video_camera_back,
            size: SizeConfig.imageSizeMultiplier * 5, color: Colors.black87),
        title: Text("Yellow Class",
            style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2, color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          height: SizeConfig.heightMultiplier * 30,
          child: ListView(
            children: [
             
              Card(
                elevation: 2,
                child: ListTile(
                  title: Text("Stream Video 1"),
                  trailing: Icon(Icons.play_arrow),
                  onTap: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                  VideoPlayer(url: "assets/11.mp4")));
                  
                  },
                ),
              ),
              Card(
                elevation: 2,
                child: ListTile(
                  title: Text("Stream Video 2"),
                  trailing: Icon(Icons.play_arrow),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                  VideoPlayer(url: "assets/video.mp4")));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
