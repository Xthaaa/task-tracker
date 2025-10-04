import 'package:flutter/material.dart';
import 'package:practice_app/inputs.dart';

class AddProduct extends StatefulWidget {
  final String? title;
  final String? body;
  final String? id;
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
        title: Text(
          widget.id != null ? "Edit Task" : "Create New Task",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.indigo[700],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[900],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo[800]!, Colors.grey[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.id != null ? Icons.edit_note : Icons.add_task,
                          color: Colors.blue[300],
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          widget.id != null
                              ? "Edit your task"
                              : "Create a new task",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.id != null
                          ? "Update the details below to modify your task"
                          : "Fill in the details below to create a new task",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Input(
                  title: widget.title,
                  body: widget.body,
                  id: widget.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
