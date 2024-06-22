import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_sample/models/commerce.dart';
import 'package:qr_sample/models/user.dart';
import 'package:qr_sample/presentation/screens/qr_screen.dart';
import 'package:qr_sample/presentation/screens/scanner_screen.dart';
import 'package:qr_sample/presentation/views/home.dart';
import 'package:qr_sample/presentation/views/profile_view.dart';
import 'package:qr_sample/presentation/views/transactions_view.dart';
import 'package:qr_sample/themes/bizz_theme.dart';
import 'package:qr_sample/viewmodels/commerce_viewmodel.dart';
import 'package:qr_sample/viewmodels/login_viewmodel.dart';

import '../../models/new_user.dart';
import '../../models/userDetail.dart';
import '../views/qr_maker_new_view.dart';
import '../views/qr_maker_view.dart';
import '../views/qr_scanner_view.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {

  final NewUser usuario;

  HomePage({required this.usuario});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<CommerceElement> _companies = [];
  int _selectedIndex = 0;
  UserDetail _userD = UserDetail.empty();

  @override
  void initState() {
    super.initState();
    // Load user detail
    _loadUserDetail();
  }

  void _loadUserDetail() async {

    LoginViewModel().getUserDetail(context, widget.usuario.email)
        .then((userDetail) {
      setState(() {
        _userD = userDetail;
      });
    })
        .catchError((error) {
      // setState(() {
      //   _isLoading = false;
      // });
      print('Error al cargar los lotes cerrados: $error');
    });

    // final companies = await CommerceService.getCompanies(widget.usuario.data.user.id.toString());
    //
    // setState(() {
    //   _companies = companies;
    // });
  }



  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;

    String nombre = widget.usuario.name;
    List<String> palabras = nombre.split(' ');
    String iniciales = '';

    if (palabras.length >= 2) {
      iniciales += palabras[0].substring(0, 1) + palabras[1].substring(0, 1);
    } else if (palabras.length > 0) {
      iniciales += palabras[0].substring(0, 1);
    }

    final screens = [
      HomeView(),
      QRScannerView(),
      // TransactionsView(
      //   userID: widget.usuario.data.user.id.toString(),
      // ),

      // QRMakerView(
      //   userID: 'V-11143144',
      //   userName: 'Raul Gomez',
      //   userDoc: 'V-11145433',
      // ),
      QrMakerNewView(),
      ProfileView(
          username: widget.usuario.name,
          idNumber: _userD.cardId.isEmpty ? 'V25157584' : _userD.cardId,
          email: widget.usuario.email,
          phone: _userD.phone.isEmpty ? '584120946704' : _userD.phone,
          companies: []
      ),
    ];

    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Scaffold(
        body: Column(
          children: [
            AppBar(
              backgroundColor: ThemeConfig.primaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 50,),
                  Image.asset(ThemeConfig.fullLogo, width: 100, height: 80),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.black,),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                  },
                ),
              ],
              elevation: 0, // Elimina la sombra del AppBar
            ),
            const Divider(
              color: ThemeConfig.secondaryColor,
              height: 1,
                thickness: 1.5
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ThemeConfig.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Lado izquierdo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fila con el círculo y el texto
                        Row(
                          children: [
                            // Círculo con iniciales del usuario
                            CircleAvatar(
                              backgroundColor: ThemeConfig.secondaryColor,
                              radius: 16,
                              child: Text(
                                iniciales, // Iniciales del usuario
                                style: TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 8), // Espaciador
                            // Texto "Bienvenido, Jonathan"
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bienvenido,',
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                ),
                                Text(
                                  palabras[0],
                                  style: TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Separador vertical
                    Container(
                      height: 40,
                      width: 1,
                      color: ThemeConfig.secondaryColor,
                    ),
                    // Lado derecho
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Identificación:',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          _userD.cardId.isEmpty ? 'V25157584' : _userD.cardId,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: screens [_selectedIndex],
            ),
          ],
        ),





        // IndexedStack(
        //   children: screens,
        //   index: _selectedIndex,
        // ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: ThemeConfig.primaryColor, // Color de fondo
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled, size: 28),
                activeIcon: Icon(Icons.home_filled, size: 28),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.document_scanner_outlined, size: 28),
                activeIcon: Icon(Icons.document_scanner_sharp, size: 28),
                label: 'Escanear',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_2_outlined, size: 28),
                activeIcon: Icon(Icons.qr_code_2_sharp, size: 28),
                label: 'Generar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined, size: 28),
                activeIcon: Icon(Icons.person_2, size: 28),
                label: 'Perfil',
              ),
              // Agregar más elementos según sea necesario
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.transparent, // Color de fondo transparente
            selectedItemColor: ThemeConfig.secondaryColor, // Color del ícono activo
            unselectedItemColor: Colors.white, // Color del ícono inactivo
            type: BottomNavigationBarType.fixed, // Para asegurar que los íconos sean visibles
            elevation: 0, // Eliminar sombra del BottomNavigationBar
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            selectedFontSize: 14, // Tamaño de la etiqueta activa
            unselectedFontSize: 14, // Tamaño de la etiqueta inactiva
          ),
        ),
      ),
    );
  }
}

