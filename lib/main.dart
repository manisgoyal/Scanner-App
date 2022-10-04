import 'package:scanner_app/fooderlich_theme.dart';

import '../providers/checkpoint_name.dart';
import 'screens/checkpoint_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckPointProvider>(
      create: (context) => CheckPointProvider(),
      child: Consumer<CheckPointProvider>(
        builder: (context, nameProvider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => const CheckPointScreen(),
          },
          title: 'Scanner App',
          theme: FooderlichTheme.dark(),
        ),
      ),
    );
  }
}
