import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpaper_app/WallpaperApp/fullscreen_image.dart';




class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {


  StreamSubscription<QuerySnapshot> subscription;
  List <DocumentSnapshot> wallpapersList;

  final CollectionReference collectionReference = Firestore.instance.collection("wallpapers");

  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot){
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
    
    
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallify"),
      ),
      body: wallpapersList != null?
       StaggeredGridView.countBuilder(
         padding: const EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: wallpapersList.length,
          itemBuilder: (context, i){
            String imgPath = wallpapersList[i].data["url"];
            return new Material(
              elevation: 8.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FullScreenImagePage(imgPath)
                  ));
                },
                child: Hero(
                  tag: imgPath,
                  child: FadeInImage(
                    placeholder: AssetImage("assets/wallfy.png"),
                    image: NetworkImage(imgPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (i) => StaggeredTile.count(2, i.isEven ? 2:3),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ): Center(
          child: CircularProgressIndicator()
        ),
    );
  }
}