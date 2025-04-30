import 'package:flutter/material.dart';
import 'package:pakapp/presentation/screens/login.screen.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaRegistro extends StatefulWidget {
  const VistaRegistro({super.key});
  @override
  State<VistaRegistro> createState() => _VistaRegistroState();
}

class _VistaRegistroState extends State<VistaRegistro> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _registrarUsuario() {
    if (_formKey.currentState!.validate()) {
      final nombres = _nombresController.text;
      final apellidos = _apellidosController.text;
      final correo = _correoController.text;
      final password = _passwordController.text;

      _formKey.currentState!.reset(); // clean
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // ocultar appbar
      resizeToAvoidBottomInset: true, // imagen atras del singlechildScroll...
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/wallpapers/wallpaperRegister.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SizedBox.expand(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Text(
                        """Registrate 
                        para 
                        comenzar""",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.bebasNeue(
                          height: 0.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 40,
                          letterSpacing: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          spacing: 16,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _nombresController,
                              decoration: const InputDecoration(
                                labelText: 'Nombres',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                focusColor: Color.fromARGB(255, 0, 89, 255),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese sus nombres';
                                }
                                return null;
                              },
                            ),

                            TextFormField(
                              controller: _apellidosController,
                              decoration: const InputDecoration(
                                labelText: 'Apellidos',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese sus apellidos';
                                }
                                return null;
                              },
                            ),

                            TextFormField(
                              controller: _correoController,
                              decoration: const InputDecoration(
                                labelText: 'Correo Electrónico',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese su correo';
                                }
                                if (!value.contains('@')) {
                                  return 'Ingrese un correo válido';
                                }
                                return null;
                              },
                            ),

                            TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Contraseña',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'La contraseña debe tener al menos 6 caracteres';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color.fromARGB(
                            255,
                            0,
                            89,
                            255,
                          ),
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _registrarUsuario;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VistaLogin(),
                            ),
                          );
                        },
                        child: const Text('Registrarse'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
