import 'package:flutter/material.dart';
import 'package:qr_sample/models/commerce.dart';
import 'package:qr_sample/models/user.dart';
import 'package:qr_sample/presentation/views/home.dart';
import 'package:qr_sample/presentation/views/profile_view.dart';
import 'package:qr_sample/presentation/views/transactions_view.dart';
import 'package:qr_sample/viewmodels/commerce_viewmodel.dart';

import '../views/qr_maker_view.dart';
import '../views/qr_scanner_view.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {

  final User usuario;

  HomePage({required this.usuario});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late List<CommerceElement> _companies = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load the list of companies associated with the user
    _loadCompanies();
  }

  void _loadCompanies() async {
// Get the list of companies from the server
    final companies = await CommerceService.getCompanies(widget.usuario.data.user.id.toString());

// Set the list of companies on the state
    setState(() {
      _companies = companies;
    });
  }



  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final screens = [
      HomeView(),
      QRScannerView(),
      TransactionsView(
        userID: widget.usuario.data.user.id.toString(),
      ),
      ProfileView(
        username: widget.usuario.data.user.name,
        idNumber: widget.usuario.data.user.cardId,
        email: widget.usuario.data.user.email,
        phone: widget.usuario.data.user.phone,
        companies: _companies
      ),
      QRMakerView(
        userID: widget.usuario.data.user.id.toString(),
        userName: widget.usuario.data.user.name,
        userDoc: widget.usuario.data.user.cardId,
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 50,),
                Image.asset('assets/Images/pluxelogo.jpg', width: 120, height: 100),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
                },
              ),
            ],
            elevation: 0, // Elimina la sombra del AppBar
          ),
          const Divider(
            color: Color(0xff00eb5e),
            height: 1,
              thickness: 1.5
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xff221c46),
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
                            backgroundColor: Colors.white,
                            radius: 16,
                            child: Text(
                              'JG', // Iniciales del usuario
                              style: TextStyle(fontSize: 14, color: Color(0xff221c46)),
                            ),
                          ),
                          SizedBox(width: 8), // Espaciador
                          // Texto "Bienvenido, Jonathan"
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bienvenido,',
                                style: TextStyle(fontSize: 14, color: Colors.white),
                              ),
                              Text(
                                'Jonathan',
                                style: TextStyle(fontSize: 16, color: Colors.white),
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
                    color: Color(0xff00eb5e),
                  ),
                  // Lado derecho
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total disponible:',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        '\$100.00', // Puedes reemplazar esto con tu monto total
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
          color: Color(0xff221c46), // Color de fondo
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
              icon: Icon(Icons.view_list_outlined, size: 28),
              activeIcon: Icon(Icons.view_list, size: 28),
              label: 'Listado',
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
          selectedItemColor: Color(0xff00eb5e), // Color del ícono activo
          unselectedItemColor: Colors.white, // Color del ícono inactivo
          type: BottomNavigationBarType.fixed, // Para asegurar que los íconos sean visibles
          elevation: 0, // Eliminar sombra del BottomNavigationBar
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          selectedFontSize: 14, // Tamaño de la etiqueta activa
          unselectedFontSize: 14, // Tamaño de la etiqueta inactiva
        ),
      ),
    );
  }
}

