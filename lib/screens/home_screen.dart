import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/alert_dialog.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'dart:io';

import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    if(productService.isLoading) {
      return const LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
        
        actions: [
          IconButton(
            onPressed: () {
              confirmCloseSession(context);
            }, 
            icon: const Icon(Icons.logout_rounded)
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.deepPurple,
        onRefresh: () async => productService.loadProducts(),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Colors.deepPurple,
            child: ListView.builder(
              itemCount: productService.products.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  productService.selectedProduct = productService.products[index].copy();
                  Navigator.pushNamed(context, 'product');
                },
                child: ProductCard(product: productService.products[index],)
              ),
              padding: const EdgeInsets.only(bottom: 88, top: 0),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productService.selectedProduct = Product(
            available: false, 
            name: "", 
            price: ""
          );
          Navigator.pushNamed(context, 'product');
        },
        child: const  Icon(Icons.add_rounded),
      ),
    );
  }
}

void confirmCloseSession(BuildContext context) {
  showDialogs(context, 
  "¿Está seguro que desea cerrar la sesión en curso?", 
  "Cerrar sesión", 
  [
    TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        "Cancelar",
        style: TextStyle(fontSize: 16, color: Colors.deepPurple),
      ),
    ),
    TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, "login");
      },
      child: const Text(
        "Aceptar",
        style: TextStyle(fontSize: 16, color: Colors.deepPurpleAccent)),
    )
  ]);
}

void showDialogs(BuildContext context, String texto, String titulo, List<Widget> actions) {
  Platform.isAndroid ? showAlertDialogAndroid(context, texto, titulo, actions) : showAlertDialogIOS(context, texto, titulo, actions);
}
