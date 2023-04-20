import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  Product product;

  ProductFormProvider(this.product); 

  updateAvailability (bool value) {
    this.product.available = value;
    notifyListeners();
  }
  
  bool idValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}