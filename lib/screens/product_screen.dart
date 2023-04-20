import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/ui/input_decoration.dart';
import 'package:productos_app/widgets/select_source_alert_dialog.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';


class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct!),
      child: _ProductsScreenBody(productService: productService),
    );
  }
}

class _ProductsScreenBody extends StatelessWidget {
  const _ProductsScreenBody({
    super.key,
    required this.productService,
  });

  final ProductService productService;

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);
  
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: productService.isSaving ? null : () async {
            FocusScope.of(context).unfocus();

            if(!productForm.idValidForm()) return;
            final String? imageUrl = await productService.uploadImage();
            if(imageUrl != null) {
              productForm.product.picture = imageUrl;
            }
            final saved = await productService.saveOrCreateProduct(productForm.product);
            if(saved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Producto guardado exitosamente"),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                )
              );
            }
          },
          backgroundColor: Colors.deepPurple,
          tooltip: "Guardar",
          child: productService.isSaving ? 
            const SizedBox(
              height: 30, 
              width: 30,
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ) 
              ),
            ) : 
            const Icon(Icons.save_rounded),
        ),
        body: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Colors.deepPurple,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ProductImage(image: productService.selectedProduct?.picture),
                      Positioned(
                        left: 10,
                        top: 5,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15)),
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context), 
                              icon: const Icon(Icons.arrow_back_rounded),
                              color: Colors.white,
                            ),
                          ),
                        )
                      ),
                      Positioned(
                        right: 10,
                        top: 5,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(15)),
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();

                                showSelectSourceDialog(
                                  context: context, 
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _rowOption(
                                          icon: Icons.camera_alt_rounded,
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final XFile? pickedFile = await picker.pickImage(
                                              source: ImageSource.camera
                                            );
                                            if(pickedFile == null) {
                                              return;
                                            }
                                            productService.updateSelectedProductImage(pickedFile.path);
                                          },
                                          text: "Cámara",
                                        ),
                                        _rowOption(
                                          icon: Icons.image_rounded,
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final XFile? pickedFile = await picker.pickImage(
                                              source: ImageSource.gallery
                                            );
                                            if(pickedFile == null) {
                                              return;
                                            }
                                            productService.updateSelectedProductImage(pickedFile.path);
                                          },
                                          text: "Galería",
                                        )
                                      ],
                                    ),
                                  ), 
                                  titulo: "Selecciona una opción", 
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Aceptar",
                                        style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
                                    )
                                  ]
                                );
                              }, 
                              icon: const Icon(Icons.camera_alt_outlined),
                              color: Colors.white,
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                  const _ProductForm(),
                  const SizedBox(height: 100)
                ],
              ),
            ),
          ),
        ),
       ),
    );
  }
}

class _rowOption extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final String text;

  const _rowOption({
    super.key, 
    required this.onPressed, 
    required this.icon, 
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 85,
          width: 85,
          alignment: Alignment.center,
          decoration: _containerBoxDecoration(),
          padding: const EdgeInsets.all(15),      
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(height: 5),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _containerBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 2),
          blurRadius: 2
        ),
      ]
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      decoration: _buildBoxDecoration(),
      child: Form(
        key: productForm.formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                cursorColor: Colors.deepPurple,
                  decoration: InputDecorations.authInputDecoration(
                  labelText: "Nombre",
                  borderColors: Colors.deepPurple,
                  labelColor: Colors.grey,
                  outlineBorder: true
                ),
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if(value == null || value.length < 1) {
                    return "El nombre es obligatorio";
                  }
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                cursorColor: Colors.deepPurple,
                keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                  labelText: "Precio",
                  borderColors: Colors.deepPurple,
                  labelColor: Colors.grey,
                  outlineBorder: true
                ),
                initialValue: product.price,
                onChanged: (value) => product.price = value,
                validator: (value) {
                  if(value == null || value.length < 1) {
                    return "El precio es obligatorio";
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
              ),
              const SizedBox(height: 10),
              SwitchListTile.adaptive(
                title: const Text("Disponible"),
                activeColor: Colors.deepPurple,
                value: product.available, 
                onChanged: productForm.updateAvailability,
              )
            ],
          ),
        ) 
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() =>  BoxDecoration(
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(15),
      bottomRight: Radius.circular(15),
    ),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ]
  );
}

showSelectSourceDialog({required BuildContext context, required Widget child, required String titulo, required List<Widget> actions}) {
    Platform.isAndroid ? showSourceAlertDialogAndroid(context, child, titulo, actions) : showSourceAlertDialogIOS(context, child, titulo, actions);
}