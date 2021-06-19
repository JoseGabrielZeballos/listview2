import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(Miapp());

class Miapp extends StatelessWidget {
  const Miapp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Miapp",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  Inicio({Key key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List data; //
  Future<List<Product>> getData() async {
    var response = await http.get(
        Uri.parse(
            "https://apprecuperaciondiego.azurewebsites.net/Api/products"),
        headers: {"Accept": "Application/json"});
    var data = json.decode(response.body);
    print(data);
    List<Product> products = [];
    for (var p in data) {
      Product product = Product(p["Productid"], p["Description"], p["Price"]);
      products.add(product);
    }
    return products;
  } //lo del api

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gabriel APP"),
        ),
        body: Container(
          child: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.data);
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Cargando.."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int productId) {
                    return ListTile(
                      title: Text(snapshot.data[productId].description),
                      subtitle: Text(snapshot.data[productId].price.toString()),
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class Product {
  final int productid;
  final String description;
  final double price;

  Product(this.productid, this.description, this.price);
}
