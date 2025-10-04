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

  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString('products');
    if (stored != null) {
      setState(() {
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
        Uri.parse('https://astha-umber.vercel.app/api/posts/$id'),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("🗑️ Task deleted successfully"),
            backgroundColor: Colors.orange[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => Ash()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Failed to delete task. Please try again."),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "My Tasks",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.indigo[700],
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              getProducts();
            },
            icon: Icon(Icons.refresh, color: Colors.white),
            tooltip: "Refresh tasks",
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo[800]!, Colors.grey[900]!],
          ),
        ),
        child: isloading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue[300]!,
                      ),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Loading your tasks...",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              )
            : products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt,
                      size: 80,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "No tasks yet",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Tap the + button to create your first task",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(20),
                      title: Text(
                        product['title'] ?? 'Untitled Task',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          product['body'] ?? 'No description',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                              icon: Icon(Icons.edit, color: Colors.blue[300]),
                              tooltip: "Edit task",
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey[800],
                                      title: Text(
                                        "Delete Task",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: Text(
                                        "Are you sure you want to delete this task?",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            deleteProducts(product['id']);
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Colors.red[400],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.delete, color: Colors.red[300]),
                              tooltip: "Delete task",
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );
        },
        icon: Icon(Icons.add),
        label: Text("New Task"),
        elevation: 4,
      ),
    );
  }
}
