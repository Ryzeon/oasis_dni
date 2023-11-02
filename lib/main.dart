import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oasis_dni/lang.dart';
import 'package:oasis_dni/screens/login_screen.dart';

Future<void> main() async {
  await dotenv.load();

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
      title: 'Hotel',
      routes: {
        'login': (_) => const LoginScreen(),
        // 'dni': (_) => const DNIScreen(),
        // 'rooms': (_) => const RoomsScreen(),
        // 'blacklist': (_) => const BlackListScreen(),
        // "payment": (context) => const PaymentScreen(),
        // "products": (context) => const ProductsScreen(),
        // "tabs": (context) => const TabsScreen(),

        // "/logs": (context) => const LoginScreen(),
        // "/logs": (context) => const LoginScreen(),
        // '/home': (context) => const HomeScreen(),
      },
      initialRoute: "login",
    );
  }
}
