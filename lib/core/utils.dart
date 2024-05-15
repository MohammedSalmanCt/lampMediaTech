import 'package:flutter/material.dart';

void showSnackBarOfFailure(BuildContext context,String message){
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Center(child: Text(message)),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      width: 500,
      elevation: 30,
    ),
    );
}

void showSnackBarOfSuccess(BuildContext context,String message){
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Center(child: Text(message)),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      width: 500,
      elevation: 30,
    ),
    );
}

