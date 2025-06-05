
import 'package:flutter/material.dart';

class HelpInformation extends StatelessWidget {

  final String title;
  final String body;

  const HelpInformation({
    super.key,
    required this.title,
    required this.body
  });

  modal(context){
    return Center(
      child: Container(
        height    : MediaQuery.of(context).size.height * 0.3,
        width     : MediaQuery.of(context).size.width * 0.3,
        margin    : const EdgeInsets.symmetric(horizontal: 20),
        padding   : const EdgeInsets.all( 20),
        decoration:  BoxDecoration(
          color       : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(12))
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(color: Colors.black)),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close),
                  )
                ],
              ),
              const Divider(),
              Text(body)
            ]
          ),
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showDialog(
          context: context, 
          builder: (context) => modal(context)
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        height    : 20,
        width     : 20,
        decoration: const BoxDecoration(
          color       : Color.fromARGB(31, 60, 60, 60),
          borderRadius: BorderRadius.all(Radius.circular(100))
        ),
        child: const Icon(Icons.question_mark_rounded, color: Colors.black, size: 12),
      )
    );
  }
}