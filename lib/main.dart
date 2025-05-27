import 'package:flutter/material.dart';
import 'package:uonly_app/providers/provider_init.dart';
import 'package:uonly_app/routing/app_routing.dart';

void main(){
  runApp(
    MultiProviderInitialise(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:AppRouting(),
    );
  }
}
