import 'package:flutter/material.dart';
import 'package:styx_app/Pages/home_page.dart';

class StyxAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? rolUsuario;
  final String currentRoute;

  const StyxAppBar({
    Key? key,
    required this.rolUsuario,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAdmin = rolUsuario == '1';

    return AppBar(
      title: const Text('Styx'),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      leading:
          isAdmin
              ? currentRoute == 'HomePage'
                  ? Builder(
                    builder:
                        (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                  )
                  : IconButton(
                    icon: const Icon(Icons.home),
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        ),
                  )
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
