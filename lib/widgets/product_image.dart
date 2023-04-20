import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? image;

  const ProductImage({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
              borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)
            ),
            child: getImage(image),
          ),
        ),
      ),
    );
  }

  Widget getImage (String? picture) {
    if(picture == null) {
      return Image.asset("assets/no-image.png", fit: BoxFit.cover,);
    }
    
    if(picture.startsWith('http')){
      return FadeInImage(
        fit: BoxFit.cover,
        placeholder: const AssetImage('assets/jar-loading.gif'), 
        image: NetworkImage(image!)
      );
    }

    return Image.file(
      File(picture),
      fit: BoxFit.cover
    );
            
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0,5)
          )
        ]
      );
  }
}