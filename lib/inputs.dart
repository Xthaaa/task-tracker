import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice_app/ash.dart';

class Input extends StatefulWidget {
  final String? title;
  final String? body;
  final String? id;
  const Input({super.key, this.body, this.title, this.id});

  @override
  State<StatefulWidget> createState() {
    return _Input();
  }
}

class _Input extends State<Input> {
  late TextEditingController titlecontroller = TextEditingController();
  late TextEditingController bodycontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    titlecontroller = TextEditingController();
    bodycontroller = TextEditingController();

    if (widget.title != null) titlecontroller.text = widget.title!;
    if (widget.body != null) bodycontroller.text = widget.body!;
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    bodycontroller.dispose();
    super.dispose();
  }

  Future<void> updateproduct() async {
    final response = await http.put(
      Uri.parse('https://astha-umber.vercel.app/api/posts/add-new-post/${widget.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titlecontroller.text,
        'body': bodycontroller.text,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("woohoo! product added bitches")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Ash()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('woopsy oopsy! failed to add product: ${addproduct()}'),
        ),
      );
    }
  }

  Future<void> addproduct() async {
    final response = await http.post(
      Uri.parse('https://astha-umber.vercel.app/api/posts/add-new-post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titlecontroller.text,
        'body': bodycontroller.text,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("woohoo! product added bitches")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Ash()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('woopsy oopsy! failed to add product: ${addproduct()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: TextField(
            controller: titlecontroller,
            decoration: InputDecoration(
              hintText: 'Name',
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: TextField(
            controller: bodycontroller,
            decoration: InputDecoration(
              hintText: 'body',
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(onPressed: 
        widget.id != null ? updateproduct : addproduct, child: Text("Submit")),
      ],
    );
  }
}
