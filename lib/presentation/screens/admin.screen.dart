import 'package:flutter/material.dart';

class VistaAdmin extends StatelessWidget {
  const VistaAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ancho total de la pantalla y padding
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 16.0;

    // Definimos cuántas columnas queremos en función del ancho.
    // Ejemplo: si el ancho es mayor a 800 px, usamos 3 columnas; si no, 2.
    int crossAxisCount = 2;
    if (screenWidth > 1200) {
      crossAxisCount = 4;
    } else if (screenWidth > 800) {
      crossAxisCount = 3;
    }

    // Lista de items para el grid (etiqueta, icono, ruta)
    final List<_MenuItem> menuItems = [
      _MenuItem(label: 'Colores', icon: Icons.color_lens_outlined, route: '/colores'),
      _MenuItem(label: 'Tallas', icon: Icons.format_size, route: '/tallas'),
      _MenuItem(label: 'Calzados', icon: Icons.shopping_bag_outlined, route: '/calzados'),
      _MenuItem(label: 'Estantes', icon: Icons.view_comfy_outlined, route: '/estantes'),
      _MenuItem(label: 'Marcas', icon: Icons.branding_watermark, route: '/marcas'),
      _MenuItem(label: 'Colaboradores', icon: Icons.people_outline, route: '/colaboradores'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("PANEL DE CONTROL"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── Botón “Pedidos” ───────────────────────────────────
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/pedidos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  icon: Icon(
                    Icons.receipt_long,
                    size: 28,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Pedidos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ─── Grid responsivo de opciones ───────────────────────
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return _AdminCard(
                          label: item.label,
                          icon: item.icon,
                          onTap: () => Navigator.pushNamed(context, item.route),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Clase para almacenar cada ítem del menú en el grid.
class _MenuItem {
  final String label;
  final IconData icon;
  final String route;

  _MenuItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

/// Tarjeta reutilizable para las opciones de administración.
class _AdminCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminCard({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        splashColor: primaryColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: primaryColor),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
