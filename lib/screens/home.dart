import 'package:flutter/material.dart';
import 'package:todo_app/api/strapi.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = ToDo.todoList();
  List<ToDo> _foundTodos = [];

  final _todoController = TextEditingController();
  var _selectedDate;
  late Future<List<ToDo>> futureTasks;

  @override
  void initState() {
    // _foundTodos = todoList;
    super.initState();
    futureTasks = ToDo.todoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  searchBox(),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50, bottom: 20),
                          child: const Text(
                            'Your Todos',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                        ),
                        for (ToDo todo in _foundTodos.reversed)
                          ToDoItem(
                            todo: todo,
                            onTodoChanged: _handleTodoChange,
                            onDeleteItem: _deleteTodoItem,
                          )
                      ],
                    ),
                  ),


                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10,
                        spreadRadius: 0.0)
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        hintText: ('Add a Todo'), border: InputBorder.none)),
              )),
              Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                  child: Icon(Icons.calendar_today_outlined),
                  onPressed: _presentDatePicker,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(58, 58),
                      elevation: 10),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 40),
                  ),
                  onPressed: () {
                    _addTodoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      minimumSize: Size(58, 58),
                      elevation: 10),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  void _handleTodoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteTodoItem(String id) {
    setState(() {
      // todoList.removeWhere((item) => item.id == id);
    });
  }

  void _addTodoItem(String todo) {
    if (todo.isEmpty) {
      return;
    }

    setState(() {
      // todoList.add(ToDo(
      //     id: DateTime.now().millisecondsSinceEpoch.toString(),
      //     title: todo,
      //     date: _selectedDate));
    });
    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) async{
    // List<ToDo> results = [];
    // if (enteredKeyword.isEmpty) {
    //   results =await todoList;
    // } else {
    //   results = await todoList
    //       .where((item) =>
    //           item.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
    //       .toList();
    // }
    //
    // setState(() {
    //   _foundTodos = results;
    // });

    // Await the future to get the actual list
    final results = await todoList;

    if (enteredKeyword.isEmpty) {
      _foundTodos = results;
    } else {
      _foundTodos = results
          .where((item) =>
          item.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {});
  }

  Widget _buildListView(List<ToDo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return ToDoItem(
          todo: todo,
          onTodoChanged: _handleTodoChange,
          onDeleteItem: _deleteTodoItem,
        );
      },
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search, color: tdBlack, size: 24),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 20),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: tdBGColor,
      title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.menu,
              color: tdBlack,
              size: 30,
            ),
            Text(
              'Todo App',
              style: TextStyle(color: tdBlack),
            )
          ]),
    );
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2024))
        .then((pickedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }
}
