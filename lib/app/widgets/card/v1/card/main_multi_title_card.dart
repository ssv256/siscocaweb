import 'package:flutter/material.dart';

class MultiTitleCard extends StatelessWidget {

  final double width;
  final double height;
  final String title;
  final String subtitle;
  final Widget content;
  final dynamic action;
  final IconData icon;

  const MultiTitleCard({
    super.key,
    this.width    = 100,
    this.height   = 100,
    this.title    = 'Title',
    this.subtitle = 'Subtitle',
    this.content  = const SizedBox(),
    this.action,
    this.icon     = Icons.menu_sharp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width     : width,
      height    : height,
            padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color       : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow   : const [
          BoxShadow(
            color       : Color.fromARGB(10, 0, 0, 0),
            blurRadius  : 5,
            spreadRadius: 2,
            offset      : Offset(0, 2),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children    : [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text(subtitle, style: const TextStyle(fontSize: 12 + 1, color: Colors.black54)),
                    ]
                  ),
                  const Spacer(),
                  Icon(
                    icon,
                    color: Colors.black,
                  )
                ]
              )
            ]
          ),
          const Divider(height: 1, color: Colors.black12,),
          content,
        ]
      )
    );
  }
}