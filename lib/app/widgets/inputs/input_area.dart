import 'package:flutter/material.dart';

class InputAreaEd extends StatelessWidget {

  final double radius;
  final bool border;
  final String title;
  final bool titleMargin;
  final dynamic titleStyle;
  final TextEditingController controller;



  const InputAreaEd({
    super.key,
    this.radius = 7.0,
    this.border = true,
    this.title = '',
    this.titleMargin = true,
    this.titleStyle = Colors.black,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title != '')
        Container(
          margin: titleMargin ? const EdgeInsets.only(top: 15, bottom: 5) : EdgeInsets.zero,
          child : Text(title, style:  TextStyle(color: titleStyle))
        ),
        TextFormField(
            minLines          : 4,
            maxLines          : null,
            keyboardType      : TextInputType.multiline,
            controller        : controller,
            decoration        : InputDecoration(
              fillColor: Colors.white,
              alignLabelWithHint: true,
              border            : OutlineInputBorder(
                borderRadius  : BorderRadius.all(Radius.circular(radius)),
                borderSide    :  BorderSide(color: border ?   Colors.black : Colors.transparent, width: .5),
              ),
              hintText          : 'Inserte texto',
              focusedBorder     : OutlineInputBorder(
                borderRadius      : BorderRadius.all(Radius.circular(radius)),
                borderSide        :  BorderSide(color: border ?   Colors.black : Colors.transparent, width: .5),
              ),
              enabledBorder     : OutlineInputBorder(
                borderRadius  : BorderRadius.all(Radius.circular(radius)),
                borderSide    : BorderSide(color: border ?   Colors.black54 : Colors.transparent, width: .5),
              ),
              disabledBorder    : OutlineInputBorder(
                borderRadius      : BorderRadius.all(Radius.circular(radius)),
                borderSide        : BorderSide(color: border ?   Colors.black : Colors.transparent, width: .5),
              ),
              errorBorder       : OutlineInputBorder(
                borderRadius      : BorderRadius.all(Radius.circular(radius)),
                  borderSide      : BorderSide(color: border ?   Colors.red : Colors.transparent, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius      : BorderRadius.all(Radius.circular(radius)),
                  borderSide      : BorderSide(color: border ?   Colors.black : Colors.transparent, width: .5),
              )
          )
        ),
      ],
    );
  }
}