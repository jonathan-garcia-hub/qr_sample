import 'package:flutter/material.dart';
import 'package:qr_sample/themes/bizz_theme.dart';

import '../../models/commerce.dart';

class ProfileView extends StatelessWidget {
  final String username;
  final String idNumber;
  final String email;
  final String phone;
  final List<CommerceElement> companies;

  ProfileView({
    required this.username,
    required this.idNumber,
    required this.email,
    required this.phone,
    required this.companies,
  });

  @override
  Widget build(BuildContext context) {

    String nombre = username;
    List<String> palabras = nombre.split(' ');
    String iniciales = '';

    if (palabras.length >= 2) {
      iniciales += palabras[0].substring(0, 1) + palabras[1].substring(0, 1);
    } else if (palabras.length > 0) {
      iniciales += palabras[0].substring(0, 1);
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  backgroundColor: ThemeConfig.secondaryColor,
                  foregroundColor: Colors.white,
                  radius: 50,
                  child: Text(
                    iniciales.toUpperCase(),
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Nombre:', username),
                          SizedBox(height: 20),
                          _buildInfoRow('Cédula:', idNumber),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Correo:', email),
                          SizedBox(height: 20),
                          _buildInfoRow('Teléfono:', phone),
                        ],
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 20),
                // Container(
                //   decoration: BoxDecoration(
                //     color: ThemeConfig.secondaryColor,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   padding: EdgeInsets.all(8),
                //   child: Center(
                //     child: Text(
                //       'Afiliaciones',
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // SizedBox(height: 10),
          // Expanded(
          //   child: ListView.separated(
          //     physics: ClampingScrollPhysics(),
          //     itemCount: companies.length,
          //     separatorBuilder: (BuildContext context, int index) {
          //       return Divider(
          //         color: Colors.grey,
          //         height: 1,
          //       );
          //     },
          //     itemBuilder: (context, index) {
          //       return _buildCompanyTile(companies[index]);
          //     },
          //   ),
          // ),
        ],
      );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(value),
          ],
        ),
      ],
    );
  }

  Widget _buildCompanyTile(CommerceElement company) {
    return ListTile(
      title: Text(company.name!),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RIF: ${company.taxId}'),
          Text('Dirección: ${company.address}'),
        ],
      ),
    );
  }
}