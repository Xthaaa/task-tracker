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
      Uri.parse(
        'https://astha-umber.vercel.app/api/posts/add-new-post/${widget.id}',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titlecontroller.text,
        'body': bodycontroller.text,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Task updated successfully!"),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => Ash()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to update task. Please try again.'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("✅ Task created successfully!"),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => Ash()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to create task. Please try again.'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: titlecontroller,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Task Title',
              hintStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.title, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: TextField(
            controller: bodycontroller,
            maxLines: 3,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Task Description',
              hintStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.description, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.id != null ? updateproduct : addproduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.id != null ? Icons.update : Icons.add),
                  SizedBox(width: 8),
                  Text(
                    widget.id != null ? "Update Task" : "Create Task",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
