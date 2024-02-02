import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transaction.dart';
import '../../viewmodels/transaction_viewmodel.dart';

// 1. Definir una clase para representar la transacción
class Transaction {
  final DateTime date;
  final String operation;
  final String referenceId;
  final double amount;
  final String description;

  Transaction({
    required this.date,
    required this.operation,
    required this.referenceId,
    required this.amount,
    required this.description,
  });
}


class TransactionsView extends StatefulWidget {
  final String userID;


  TransactionsView({
    required this.userID
  });

  @override
  _TransactionsViewState createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {

  late List<QrTransaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load the list of companies associated with the user
    _loadTransactions();
  }

  void _loadTransactions() async {
// Get the list of companies from the server
    final transactions = await TransactionService.getTransactions(widget.userID);

// Set the list of companies on the state
    setState(() {
      // _isLoading = false;
      _transactions = transactions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Agrupar las transacciones por fecha
    Map<String, List<QrTransaction>> transactionsByDate = {};
    for (var transaction in _transactions) {
      final formattedDate =
          '${DateFormat('EEEE, d MMMM').format(transaction.date).toUpperCase()}';
      transactionsByDate.putIfAbsent(formattedDate, () => []);
      transactionsByDate[formattedDate]!.add(transaction);
    }

    return Scaffold(
      body:
      _isLoading?
      Center(
          child: CircularProgressIndicator()
      ):
      Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0), // Espacio en los lados y arriba
        child: ListView.separated(
          itemCount: transactionsByDate.length,
          itemBuilder: (context, index) {
            final date = transactionsByDate.keys.elementAt(index);
            final transactionsForDate = transactionsByDate[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: transactionsForDate.length,
                  itemBuilder: (context, index) {
                    final transaction = transactionsForDate[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Espacio entre elementos de la lista
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Column para alinear el nombre a la derecha y el ID de referencia debajo
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                transaction.operation.name == "PAY" ?
                                  Row(
                                    children: [ // Espacio entre el nombre y el icono de la derecha
                                      Icon(
                                          Icons.arrow_circle_up,
                                          color: Colors.red
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        "Pago QR",
                                        style: TextStyle(fontSize: 16.0), // Tamaño del nombre
                                      ),
                                      // Icono al lado derecho del nombre de la transacción
                                    ],
                                  )
                                :
                                  Row(
                                    children: [ // Espacio entre el nombre y el icono de la derecha
                                      Icon(Icons.arrow_circle_down,
                                          color: Colors.green),
                                      SizedBox(width: 8.0),
                                      Text(
                                        "Cobro QR",
                                        style: TextStyle(fontSize: 16.0), // Tamaño del nombre
                                      ),
                                      // Icono al lado derecho del nombre de la transacción
                                    ],
                                  ),
                                SizedBox(height: 4.0), // Espacio entre el nombre y el ID de referencia
                                Text(
                                  '${transaction.referenceId}',
                                  style: TextStyle(fontSize: 14.0), // Tamaño del ID de referencia
                                ),
                              ],
                            ),
                            // Column para alinear la hora debajo del monto
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${transaction.amount} Bs',
                                  style: TextStyle(fontSize: 18.0), // Tamaño del monto
                                ),
                                SizedBox(height: 4.0), // Espacio entre el monto y la hora
                                Text(
                                  '${transaction.date.hour}:${transaction.date.minute}',
                                  style: TextStyle(fontSize: 14.0), // Tamaño de la hora
                                ),
                              ],
                            ),

                          ],
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                            ),
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          'Detalles de transacción',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 24.0),
                                      Text('Tipo de transacción:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(transaction.operation.name, style: TextStyle(fontSize: 18.0)),

                                      SizedBox(height: 12.0),
                                      Text('Código de referencia:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(transaction.referenceId, style: TextStyle(fontSize: 18.0)),

                                      SizedBox(height: 12.0),
                                      Text('Monto de la Transacción:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${transaction.amount} Bs", style: TextStyle(fontSize: 18.0)),

                                      SizedBox(height: 12.0),
                                      Text('Fecha:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${transaction.date}", style: TextStyle(fontSize: 18.0)),

                                      SizedBox(height: 12.0),
                                      Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(transaction.description, style: TextStyle(fontSize: 18.0)),

                                      SizedBox(height: 12.0),
                                      Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(transaction.description, style: TextStyle(fontSize: 18.0)),

                                      SizedBox(height: 20.0),

                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return Divider(); // Divisor entre las secciones de fecha
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 4. Actualizar manualmente la lista de transacciones (puedes agregar lógica para cargar nuevos datos)
          setState(() {
            _isLoading = true;
            _loadTransactions();

            // _transactions = [
            //   Transaction(
            //     date: DateTime.now(),
            //     operation: "Nuevo Ejemplo",
            //     referenceId: "REF789",
            //     amount: 200.0,
            //     description: "Descripción de la nueva transacción",
            //   ),
            //   ..._transactions,
            // ];
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}











  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: ListView.builder(
  //       itemCount: transactions.length,
  //       itemBuilder: (context, index) {
  //         final transaction = transactions[index];
  //         return Padding(
  //           padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
  //           child: ListTile(
  //             title: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 // Column para alinear el nombre a la derecha y el ID de referencia debajo
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: [
  //                     Row(
  //                       children: [ // Espacio entre el nombre y el icono de la derecha
  //                         Icon(Icons.payments_sharp),
  //                         SizedBox(width: 8.0),
  //                         Text(
  //                           transaction.name,
  //                           style: TextStyle(fontSize: 16.0), // Tamaño del nombre
  //                         ),
  //                          // Icono al lado derecho del nombre de la transacción
  //                       ],
  //                     ),
  //                     SizedBox(height: 4.0), // Espacio entre el nombre y el ID de referencia
  //                     Text(
  //                       'ID Ref: ${transaction.referenceId}',
  //                       style: TextStyle(fontSize: 14.0), // Tamaño del ID de referencia
  //                     ),
  //                   ],
  //                 ),
  //                 // Column para alinear la hora debajo del monto
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       '\$${transaction.amount}',
  //                       style: TextStyle(fontSize: 18.0), // Tamaño del monto
  //                     ),
  //                     SizedBox(height: 4.0), // Espacio entre el monto y la hora
  //                     Text(
  //                       '${transaction.date.hour}:${transaction.date.minute}',
  //                       style: TextStyle(fontSize: 14.0), // Tamaño de la hora
  //                     ),
  //                   ],
  //                 ),
  //
  //               ],
  //             ),
  //             onTap: () {
  //               showModalBottomSheet(
  //                 context: context,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
  //                 ),
  //                 builder: (BuildContext context) {
  //                   return SingleChildScrollView(
  //                     child: Container(
  //                       padding: const EdgeInsets.all(24.0),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Center(
  //                             child: Text(
  //                               'Detalles de transacción',
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 24.0,
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 24.0),
  //                           Text('Tipo de transacción:', style: TextStyle(fontWeight: FontWeight.bold)),
  //                           Text(transaction.name, style: TextStyle(fontSize: 18.0)),
  //                           SizedBox(height: 12.0),
  //                           Text('Código de referencia:', style: TextStyle(fontWeight: FontWeight.bold)),
  //                           Text(transaction.referenceId, style: TextStyle(fontSize: 18.0)),
  //                           SizedBox(height: 12.0),
  //                           Text('Monto de la Transacción:', style: TextStyle(fontWeight: FontWeight.bold)),
  //                           Text("${transaction.amount}", style: TextStyle(fontSize: 18.0)),
  //                           SizedBox(height: 12.0),
  //                           Text('Fecha:', style: TextStyle(fontWeight: FontWeight.bold)),
  //                           Text("${transaction.date}", style: TextStyle(fontSize: 18.0)),
  //                           SizedBox(height: 12.0),
  //                           Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
  //                           Text(transaction.description, style: TextStyle(fontSize: 18.0)),
  //                           SizedBox(height: 24.0),
  //
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //         );
  //       },
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         // 4. Actualizar manualmente la lista de transacciones (puedes agregar lógica para cargar nuevos datos)
  //         setState(() {
  //           transactions = [
  //             Transaction(
  //               date: DateTime.now(),
  //               name: "Nuevo Ejemplo",
  //               referenceId: "REF789",
  //               amount: 200.0,
  //               description: "Descripción de la nueva transacción",
  //             ),
  //             ...transactions,
  //           ];
  //         });
  //       },
  //       child: Icon(Icons.refresh),
  //     ),
  //   );
  // }
  //



