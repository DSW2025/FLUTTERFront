import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pakapp/presentation/providers/calzadoPorEstante.provider.dart';
import 'package:pakapp/presentation/providers/cart.provider.dart';
import 'package:pakapp/presentation/screens/admin.screen.dart';
import 'package:pakapp/presentation/screens/calzado.screen.dart';
import 'package:pakapp/presentation/screens/carrrito.screen.dart';
import 'package:pakapp/presentation/screens/colaborador.screen.dart';
import 'package:pakapp/presentation/screens/colores.screen.dart';
import 'package:pakapp/presentation/screens/estante.screen.dart';
import 'package:pakapp/presentation/screens/marca.screen.dart';
import 'package:pakapp/presentation/screens/pedidos.screen.dart';
import 'package:pakapp/presentation/screens/talla.screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pakapp/presentation/providers/auth.provider.dart';
import 'package:pakapp/presentation/providers/capacidad.priver.dart';
import 'package:pakapp/presentation/providers/chat.provider.dart';
import 'package:pakapp/presentation/providers/estante.provider.dart';
import 'package:pakapp/presentation/providers/navigator.provider.dart';
import 'package:pakapp/presentation/screens/chat.screen.dart';
import 'package:pakapp/presentation/screens/codeBard.screen.dart';
import 'package:pakapp/presentation/screens/home.screen.dart';
import 'package:pakapp/presentation/screens/login.screen.dart';
import 'package:pakapp/presentation/screens/map.screen.dart';
import 'package:pakapp/presentation/screens/regiter.screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = 'pk_test_51RWCPvRHG6LnRhg6SzV1KVCLa068IpWxvnRE8sXhttdsi1p00HEOpq3NIp1GBXYPQ2yP0XHQ5ZTdZmLz0d4bYlmP009RNlomRW';

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

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
        ChangeNotifierProvider(create: (_) => CapacidadProvider()),
        ChangeNotifierProvider(create: (_) => EstantesProvider()),
        ChangeNotifierProvider(create: (_) => CalzadosPorEstanteProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => VistaLogin(),
          '/home': (context) => VistaHome(),
          '/admin': (context) => VistaAdmin(),
          '/colores': (context) => VistaColores(),
          '/tallas': (context) => VistaTallas(),
          '/estantes': (context) => VistaEstantes(),
          '/marcas': (context) => VistaMarcas(),
          '/colaboradores': (context) => VistaColaboradores(),
          '/calzados': (context) => VistaCalzados(),
          '/pedidos': (context) => VistaPedidos(),
          '/carrito': (context) => VistaCarrito(),
          '/register': (context) => VistaRegistro(),
          '/chatbot': (context) => VistaChatBot(),
          '/codeBars': (context) => VistaCodigoBarras(),
          '/map': (context) => VistaMapaEstanterias(),
        },
      ),
    );
  }
}
