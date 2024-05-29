import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoItem> _todoList = [];
  bool _isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO DO LIST'),
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return buildTodoItem(_todoList[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isDialogOpen = true;
          });
          _showAddTodoDialog(context).then((_) {
            setState(() {
              _isDialogOpen = false;
            });
          });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: 'text',
          ),
        ],
      ),
    );
  }

  Widget buildTodoItem(TodoItem todoItem) {
    return GestureDetector(
      onTap: () {
        setState(() {
          todoItem.isExpanded = !todoItem.isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white54, Colors.grey],
          ),
        ),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        todoItem.isChecked = !todoItem.isChecked;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          todoItem.title,
                          style: TextStyle(
                              fontSize: 20,
                              decoration: (todoItem.isChecked) ? TextDecoration.lineThrough : TextDecoration.none,
                              decorationThickness: 2.5
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Checkbox(
                    visualDensity: VisualDensity.compact,
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return Colors.white;
                    }),
                    value: todoItem.isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        todoItem.isChecked = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (todoItem.isExpanded)
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey.shade200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '상세사항',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(text: todoItem.detail),
                      onChanged: (value) {
                        todoItem.detail = value;
                      },
                      decoration: const InputDecoration(
                        hintText: '상세사항을 입력하세요',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddTodoDialog(BuildContext context) async {
    String newTodo = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        String newDetail = '';
        return AlertDialog(
          title: const Text('할 일 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newTodo = value;
                },
                decoration: const InputDecoration(hintText: '할 일을 입력하세요'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  if (newTodo.isNotEmpty) {
                    _todoList.add(TodoItem(title: newTodo, detail: newDetail, isChecked: false));
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('추가'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}

class TodoItem {
  final String title;
  String detail;
  bool isChecked;
  bool isExpanded;

  TodoItem({required this.title, this.detail = '', required this.isChecked, this.isExpanded = false});
}