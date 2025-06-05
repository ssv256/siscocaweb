// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EdCard extends StatelessWidget {
  final String title;
  final Widget content;
  final dynamic onTap;
  final bool margin;

  const EdCard({
    super.key,
    required this.title,
    required this.content,
    this.margin = true,
    this.onTap,
  });

  titleW(){
    return  Container(
      margin: const EdgeInsets.only(bottom: 20),
      child : Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            height: 25,
            width : 7,
            color : Get.theme.primaryColorLight,
          ),
          Text(title, style: Get.theme.textTheme.headlineSmall!.copyWith(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.start, ),
        ]
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin    : margin ? const EdgeInsets.symmetric(horizontal: 15, vertical: 20 ) : null,
      padding   : const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: const BoxDecoration( 
        border: Border.fromBorderSide(BorderSide( color: Color.fromARGB(255, 233, 233, 239))),
        borderRadius:  BorderRadius.all(Radius.circular(15)),
      ),
      child     : InkWell(
        onTap   : onTap,
        child   : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children          : [
            titleW(),
            content
          ]
        )
      )
    );
  }
}