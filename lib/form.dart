import 'package:flutter/material.dart';
import 'package:practice_app/inputs.dart';

class AddProduct extends StatefulWidget {
  final String? title;
  final String? body;
  final  String? id;
const AddProduct({super.key, this.title, this.body, this.id});
  
  @override
  State<StatefulWidget> createState() {
    return _AddProduct();
  }
}
class _AddProduct extends State<AddProduct> {

  @override
  void initState() {
    super.initState();
  }

 @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Product:)"),
      ),
      backgroundColor: const Color.fromARGB(255, 98, 49, 32) ,
      body: Input(
        title: widget.title,
        body: widget.body,
        id: widget.id,
      ),
    );
  }
}