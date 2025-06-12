import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';

class WelcomePage extends StatefulWidget {
  final String email;
  final String? fotoUrl;
  const WelcomePage({
    Key? key,
    required this.email,
    this.fotoUrl,
  }) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final AnimationController _hintController;
  late final Animation<Offset> _hintAnimation;
  late final AnimationController _entryController;
  late final Animation<Offset> _slideEntry;
  late final Animation<double> _fadeEntry;

  @override
  void initState() {
    super.initState();

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _hintAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _slideEntry = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _fadeEntry = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeIn),
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _hintController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  String get _displayName {
    final raw = widget.email.split('@').first;
    if (raw.isEmpty) return '';
    return raw[0].toUpperCase() + raw.substring(1).toLowerCase();
  }

  String get _initial => _displayName.isNotEmpty ? _displayName[0] : '?';

  Widget _buildDrawer() => Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          UserAccountsDrawerHeader(
            accountName: Text(_displayName),
            accountEmail: Text(widget.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.success,
              backgroundImage: widget.fotoUrl != null
                  ? AssetImage(widget.fotoUrl!)
                  : null,
              child: widget.fotoUrl == null
                  ? Text(_initial,
                      style:
                          const TextStyle(fontSize: 24, color: Colors.white))
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.insert_chart),
            title: const Text('Desenvolvimento'),
            onTap: () {
              Navigator.of(context).pop();
              Modular.to.pushNamed(
                '/dashboard',
                arguments: {'email': widget.email},
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Catálogo'),
            onTap: () {
              Navigator.of(context).pop();
              Modular.to.pushNamed(
                '/catalog',
                arguments: {
                  'email': widget.email,
                  'fotoUrl': widget.fotoUrl,
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale),
            title: const Text('Minhas Vendas'),
            onTap: () {
              Navigator.of(context).pop();
              Modular.to.pushNamed(
                '/venda/sales',
                arguments: {
                  'email': widget.email,
                  'fotoUrl': widget.fotoUrl,
                },
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.of(context).pop();
              Modular.to.pushNamed(
                '/profile',
                arguments: {
                  'email': widget.email,
                  'fotoUrl': widget.fotoUrl,
                },
              );
            },
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (d) {
        if (d.globalPosition.dx < 50 && d.delta.dx > 10) {
          _scaffoldKey.currentState?.openDrawer();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawerEdgeDragWidth: 50,
        drawer: _buildDrawer(),
        appBar: AppBar(
          title: const Text('Bem‐vindo'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => Modular.to.pushNamed(
                  '/profile',
                  arguments: {
                    'email': widget.email,
                    'fotoUrl': widget.fotoUrl,
                  },
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.success,
                  backgroundImage: widget.fotoUrl != null
                      ? AssetImage(widget.fotoUrl!)
                      : null,
                  child: widget.fotoUrl == null
                      ? Text(_initial,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))
                      : null,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: SlideTransition(
                position: _slideEntry,
                child: FadeTransition(
                  opacity: _fadeEntry,
                  child: Text(
                    'Olá, $_displayName!',
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 16,
              child: SlideTransition(
                position: _hintAnimation,
                child: Row(
                  children: const [
                    Icon(Icons.arrow_forward_ios, size: 20),
                    SizedBox(width: 4),
                    Text('Arraste para abrir',
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
