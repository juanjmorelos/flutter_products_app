import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Container(
        margin: const EdgeInsets.only(top: 18),
        width: double.infinity,
        height: 250,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(product: product), 
            _ProductDetails(product: product),
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(product: product)
            ),
            if(!product.available)
              const Positioned(
                top: 0,
                left: 0,
                child: _NotAvailable()
              )
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 1))
        ]);
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.yellow[800],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)
        )
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "No disponible",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final Product product;
  
  const _PriceTag({
    super.key, required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 35,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10)
        )
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text("\$${product.price}", style: const TextStyle(color: Colors.white, fontSize: 20),),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final Product product;
  const _ProductDetails({
    super.key, required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        height: 61,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.id ?? "",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), topRight: Radius.circular(10)));
}

class _BackgroundImage extends StatelessWidget {
  final Product product;

  const _BackgroundImage({super.key, required this.product});
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: product.picture != null ? FadeInImage(
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(product.picture!),
          fit: BoxFit.cover,
        ) : 
        Image.asset("assets/no-image.png", fit: BoxFit.cover,),
      ),
    );
  }
}
