import 'package:firebase_multifactor_auth/pagination_without_getx/pagination_without_getx.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaginationWithoutGetX(),
    );
  }
}

