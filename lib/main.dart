import 'package:flutter/material.dart';
import 'package:pakapp/presentation/providers/auth.provider.dart';
import 'package:pakapp/presentation/providers/capacidad.priver.dart';
import 'package:pakapp/presentation/providers/chat.provider.dart';
import 'package:pakapp/presentation/providers/navigator.provider.dart';
import 'package:pakapp/presentation/screens/chat.screen.dart';
import 'package:pakapp/presentation/screens/codeBard.screen.dart';
import 'package:pakapp/presentation/screens/home.screen.dart';
import 'package:pakapp/presentation/screens/login.screen.dart';
import 'package:pakapp/presentation/screens/map.screen.dart';
import 'package:pakapp/presentation/screens/regiter.screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProvedorChat()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CapacidadProvider())
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => VistaLogin(),
          '/home': (context) => VistaHome(),
          '/register': (context) => VistaRegistro(),
          '/chatbot': (context) => VistaChatBot(),
          '/codeBars': (context) => VistaCodigoBarras(),
          '/map': (context) => VistaMapaEstanterias(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
