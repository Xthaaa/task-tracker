//ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice_app/form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ash extends StatefulWidget {
  const Ash({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AshState();
  }
}

class _AshState extends State<Ash> {
  List<Map<String, dynamic>> products = [];
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    loadFromLocal();
    getProducts();
  }

  Future<void> loadFromLocal() async{
    final prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString('products');
    if(stored != null){
      setState( () {
        products = List<Map<String, dynamic>>.from(json.decode(stored));
        isloading = false;
      });
    }
  }

  Future<void> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://astha-umber.vercel.app/api/posts'),
      );
      if (response.statusCode == 200) {
        setState(() {
          products = List<Map<String, dynamic>>.from(
            json.decode(response.body),
          );
          isloading = false;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('products', json.encode(products));
      }
    } catch (e) {
      print(e);
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> deleteProducts(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://astha-umber.vercel.app/api/posts/${id}'),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(" Deleted :,< ")));
        Navigator.push(context, MaterialPageRoute(builder: (context) => Ash()));
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(product['title']),
                    subtitle: Text(product['body']),
                    trailing: Wrap(
                      spacing: 5,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProduct(
                                  title: product['title'],
                                  body: product['body'],
                                  id: product['id'],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteProducts(product['id']);
                          },
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 21, 62, 132),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );
        },
      ),
    );
  }
}
