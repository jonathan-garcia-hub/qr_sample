import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:qr_sample/presentation/views/transactions_view.dart';
import 'package:qr_sample/themes/bizz_theme.dart';
import 'package:qr_sample/viewmodels/login_viewmodel.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../models/afilliation.dart';
import '../../models/listTransaction.dart';

class HomeView extends StatefulWidget {

  HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

//QR SCREEN
class _HomeViewState extends State<HomeView> {
  PageController _pageController = PageController();
  late Future<List<ListTransaction>> _transactionFuture;
  late Future<List<Afiliation>> _afiliationFuture;

  // List<YourCreditCardModel> creditCards = [
  //   YourCreditCardModel(number: 'V25157584', balance: 500.00, image: ThemeConfig.smallLogo, color: ThemeConfig.secondaryColor),
  //   YourCreditCardModel(number: '**** **** **** 1234', balance: 100.00, image: 'assets/Images/plx.png', color: Colors.blue),
  //   YourCreditCardModel(number: '**** **** **** 5678', balance: 150.00, image: 'assets/Images/plx.png', color: Colors.red),
  //   YourCreditCardModel(number: '**** **** **** 9012', balance: 200.00, image: 'assets/Images/plx.png', color: Colors.green),
  // ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadAfiliations();
  }

  void _loadTransactions() {
    setState(() {
      _transactionFuture = Provider.of<LoginViewModel>(context, listen: false).getListTransactions(context);
    });
  }

  void _loadAfiliations() {
    setState(() {
      _afiliationFuture = Provider.of<LoginViewModel>(context, listen: false).getAfiliation(context);
    });
  }

  int _selectedCardIndex = 0;

// Página actual del carrusel
//   Expanded(
//   child: TransactionListWidget(
//   selectedCard: creditCards[_selectedCardIndex]),
//   ),

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
        builder: (context, afiliations, _) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 200,
                  child: FutureBuilder(
                    future: _afiliationFuture,
                    builder: (context, AsyncSnapshot<List<Afiliation>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            height: 180,
                            child: SpinKitCircle(
                              color: ThemeConfig.secondaryColor,
                              size: 60.0,
                            ),
                          ),
                        );
                      }

                      final afiliations = snapshot.data!;

                      return
                        afiliations.isEmpty ?
                        Center(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 250),
                            // height: 180,
                            child: Column(
                              // constraints: BoxConstraints(maxWidth: 250),
                              // height: 180,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(ThemeConfig.altLogo, width: 60, height: 60),
                                  Text("¡Aún no hay afiliaciones!",textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ThemeConfig.tertiaryColor)),
                                  SizedBox(height: 5,),
                                  Text("No se han logrado cargar las afiliaciones, asegurate de tener una conexión estable a internet.",textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
                                  IconButton(
                                    icon: Icon(Icons.refresh, color: ThemeConfig.secondaryColor,),
                                    onPressed: () {
                                      setState(() {
                                        _loadAfiliations();
                                      });
                                    },
                                  ),
                                ]
                            ),
                          ),
                        ):
                        PageView.builder(
                          itemCount: afiliations.length,
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedCardIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return YourCreditCardWidget(
                                afiliation: afiliations[index]);
                          },
                        );
                    }
                  ),
                ),
                // SizedBox(height: 10),
                // DotsIndicator(
                //   controller: _pageController,
                //   itemCount: creditCards.length,
                //   onPageSelected: (index) {
                //     _pageController.animateToPage(
                //       index,
                //       duration: Duration(milliseconds: 500),
                //       curve: Curves.ease,
                //     );
                //   },
                // ),
                const SizedBox(height: 20),

                Expanded(
                  child: FutureBuilder(
                      future: _transactionFuture,
                      builder: (context, AsyncSnapshot<List<ListTransaction>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 150),
                              height: 180,
                              child: SpinKitCircle(
                                color: ThemeConfig.secondaryColor,
                                size: 60.0,
                              ),
                            ),
                          );
                        }

                        final transactions = snapshot.data!;

                        return
                          transactions.isEmpty ?
                          Center(
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 250),
                              // height: 180,
                              child: Column(
                                // constraints: BoxConstraints(maxWidth: 250),
                                // height: 180,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(ThemeConfig.altLogo, width: 60, height: 60),
                                    Text("¡Aún no hay transacciones!",textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ThemeConfig.tertiaryColor)),
                                    SizedBox(height: 5,),
                                    Text("Comienza realizando tu primera transacción.",textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey)),
                                    IconButton(
                                      icon: Icon(Icons.refresh, color: ThemeConfig.secondaryColor,),
                                      onPressed: () {
                                        setState(() {
                                          _loadTransactions();
                                        });
                                      },
                                    ),
                                  ]
                              ),
                            ),
                          )
                              :
                              //CAMBIAR ESTE PAGE BUILDER POR EL LISTADO DE TRANSACCIONES
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Listado de transacciones",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: () {
                                      setState(() {
                                        _loadTransactions();
                                      });
                                    },
                                  ),
                                ],
                              ),

                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction = transactions[index];
                                    return TransactionCard(transaction: transaction);
                                  },
                                ),
                              ),
                            ],
                          );
                      }
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}



class TransactionCard extends StatelessWidget {
  final ListTransaction transaction;

  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'A':
        return Colors.green;
      case 'C':
        return Colors.red;
      case 'P':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              child: Text(
                transaction.status,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: _getStatusColor(transaction.status),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(transaction.date),
                ],
              ),
            ),
            SizedBox(width: 16),
            Text(
              "\$${transaction.amount}",
              // "S10002.43",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(transaction.status),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}








class YourCreditCardWidget extends StatelessWidget {
  final Afiliation afiliation;

  YourCreditCardWidget({required this.afiliation});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ThemeConfig.secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                ThemeConfig.smallLogo,
                width: 40,
                height: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  afiliation.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  afiliation.taxCardId,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  afiliation.address,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  afiliation.balance.toStringAsFixed(2),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Agrega cualquier otro contenido de la tarjeta aquí
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YourCreditCardModel {
  final String number;
  final double balance;
  final String image;
  final Color color;

  YourCreditCardModel({required this.number, required this.balance, required this.image, required this.color});
}

// DotsIndicator es un widget de ejemplo, asegúrate de tenerlo implementado o reemplázalo con tu propia implementación
class DotsIndicator extends StatelessWidget {
  final PageController controller;
  final int itemCount;
  final ValueChanged<int> onPageSelected;

  DotsIndicator({
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
            (index) => buildDot(index),
      ),
    );
  }

  Widget buildDot(int index) {
    bool isSelected = index == controller.page?.round();

    return GestureDetector(
      onTap: () => onPageSelected(index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        width: isSelected ? 12 : 8,
        height: isSelected ? 12 : 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? ThemeConfig.primaryColor : Colors.grey,
        ),
      ),
    );
  }
}








class TransactionListWidget extends StatelessWidget {
  final YourCreditCardModel selectedCard;

  TransactionListWidget({required this.selectedCard});

  @override
  Widget build(BuildContext context) {
    // Lógica para obtener las últimas transacciones de la tarjeta seleccionada (aquí se utiliza una lista de ejemplo)
    List<TransactionModel> transactions = getTransactionsForCard(selectedCard);

    return Container(
      padding: EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.grey),
      //   borderRadius: BorderRadius.circular(15),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Últimas transacciones (${selectedCard.number})',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionItemWidget(transaction: transactions[index]);
              },
            ),
          ),



        ],
      ),
    );
  }

  // Esta función simula la obtención de las últimas transacciones de la tarjeta seleccionada
  List<TransactionModel> getTransactionsForCard(YourCreditCardModel card) {
    // Aquí deberías implementar la lógica real para obtener las transacciones
    // Puedes llamar a una API, acceder a una base de datos, etc.
    // Devolveré una lista de ejemplo para demostración.
    return [
      TransactionModel(description: 'Compra en tienda', amount: -30.00, date: '2024-01-24'),
      TransactionModel(description: 'Depósito de salario', amount: 1000.00, date: '2024-01-23'),
      TransactionModel(description: 'Retiro de cajero', amount: -50.00, date: '2024-01-22'),
      TransactionModel(description: 'Pago de factura', amount: -20.00, date: '2024-01-21'),
      TransactionModel(description: 'Compra en línea', amount: -40.00, date: '2024-01-20'),
      TransactionModel(description: 'Transferencia recibida', amount: 75.00, date: '2024-01-19'),
    ];
  }
}

class TransactionItemWidget extends StatelessWidget {
  final TransactionModel transaction;

  TransactionItemWidget({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.description,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                transaction.date,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            '\$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: transaction.amount < 0 ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionModel {
  final String description;
  final double amount;
  final String date;

  TransactionModel({required this.description, required this.amount, required this.date});
}