import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageScreen extends StatefulWidget {
  ImageScreen(this.imageUrl);
  final List<dynamic> imageUrl;

  @override
  _ImageScreenState createState() => _ImageScreenState(imageUrl);
}

class _ImageScreenState extends State<ImageScreen> {
  _ImageScreenState(this.imageUrl);
  final List<dynamic> imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoViewGallery.builder(
        enableRotation: true,
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imageUrl[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
          );
        },
        itemCount: imageUrl.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
      ),
    );
  }
}
