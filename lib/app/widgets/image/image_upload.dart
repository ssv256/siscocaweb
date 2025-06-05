

import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageUpload extends StatelessWidget {
  final dynamic onTap;
  final Uint8List?  file;
  final String  image;
  final double height;
  final double width;
  final double radius;
  final double padding;
  final double margin;
  final Color color;
  final Color iconColor;

  const ImageUpload({
    super.key,
    this.onTap, 
    this.file, 
    required this.image, 
    this.height   = 100.0,
    this.width    = 100.0,
    this.radius   = 10.0,
    this.padding  = 0.0,
    this.margin   = 0.0,
    this.color    = const Color.fromARGB(10, 0, 0, 0),
    this.iconColor= const  Color.fromARGB(255, 91, 91, 91)
  });

  url(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(image, fit: BoxFit.cover,loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
            : null,
          ),
        );
      },)
    );
  }
  
  local(){
    return file != null && file!.isNotEmpty
    ? ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child:  Image.memory(file!, fit: BoxFit.cover )
    ) 
    : const Padding(
        padding: EdgeInsets.all(30),
        child  : Icon(Icons.image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin        : EdgeInsets.symmetric(horizontal: margin),
        child         : InkWell(
          onTap: onTap,
          child: Container(
            width         : width,
            height        : height,
            padding       :  EdgeInsets.all(padding),
            decoration    :  BoxDecoration(
              color       :  color,
              borderRadius:   BorderRadius.all(Radius.circular(radius)),
            ),
            child: file != null && file!.isNotEmpty
            ? local() 
            :  image.isEmpty 
              ?  Padding(padding: const EdgeInsets.all(30),child  : Icon(Icons.image, color:iconColor)) 
              :  url()
          )
        )
      )
    );
  }


}