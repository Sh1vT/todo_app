import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  List todoItems = [
  ];

  void _loadData () async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/todolist.txt');
      if (await file.exists()) {
        final data = await file.readAsString();
        setState(() {
          todoItems = List.from(json.decode(data));
        });
      }
    } catch (e) {
      print('ERROR LOADING');
    }
  }

  void _saveData () async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/todolist.txt');
      final data = json.encode(todoItems);
      await file.writeAsString(data);
    } catch (e) {
      print('ERROR SAVING');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void addItem () {
    showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
        content: TextField(
          textInputAction: TextInputAction.go,
          onSubmitted: (value) {
            setState(() {
              todoItems.add([value,false]);
              _saveData();
              });
            },
          ),
        );
      }
    );
  }

  TextStyle textDecoration = const TextStyle(decoration: TextDecoration.none);

  void textDecorationCheck (index) {
    if (todoItems[index][1] ==true){
      textDecoration = const TextStyle(
        decoration: TextDecoration.lineThrough);
    }
    else {
      textDecoration = const TextStyle(
        decoration: TextDecoration.none);
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: addItem, 
        child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Text('To-do'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: todoItems.length,
          itemBuilder: (context, index){
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    )
                  ),
                  child: ListTile(
                    leading: Checkbox(value: todoItems[index][1], onChanged: (bool? value){
                      setState(() {
                        todoItems[index][1] = !todoItems[index][1];
                        textDecorationCheck(index);
                      });
                    }),
                    title: Text(
                      todoItems[index][0],
                      style: textDecoration),
                    trailing: ElevatedButton(
                      style: ButtonStyle(
                        elevation: const MaterialStatePropertyAll(0),
                        backgroundColor: MaterialStatePropertyAll(Colors.grey[900]),
                      ),
                      onPressed: (){
                        setState(() {
                          todoItems.removeAt(index);
                          _saveData();
                        });
                      }, 
                      child: const Icon(Icons.cancel),
                      ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
