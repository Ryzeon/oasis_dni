import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oasis_dni/env/environment.dart';
import 'package:oasis_dni/lang.dart';
import 'package:oasis_dni/screens/login_screen.dart';

Future<void> main() async {
  await dotenv.load(
    fileName: Envionment.fileName
  );

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        secondaryHeaderColor: Lang.primaryColor.getColor(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Hotel DNI',
      routes: {
        'login': (_) => const LoginScreen()
      },
      initialRoute: "login",
    );
  }
}
