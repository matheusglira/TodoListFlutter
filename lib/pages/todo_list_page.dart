import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Todo> tasks = [];
  Todo? deletedTask;
  int? position;

  final TextEditingController nota = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicione uma Tarefa',
                            hintText: 'Ex: Limpar o quarto'),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: addTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff5f6197),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(16),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 30,
                        )),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo task in tasks)
                        TodoListItem(
                          todo: task,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text("Você possui ${tasks.length} tarefas pendentes"),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                        onPressed: deleteAll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff5f6197),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.all(16),
                        ),
                        child: Text("Limpar tudo"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTask() {
    String text = todoController.text;
    setState(() {
      if (todoController.text.isNotEmpty) {
        Todo newTodo = Todo(title: text, date: DateTime.now());
        tasks.add(newTodo);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Campo de tarefa vazio!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    todoController.clear();
  }

  void onDelete(Todo todo) {
    deletedTask = todo;
    position = tasks.indexOf(todo);

    setState(() {
      tasks.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso!',
          style: TextStyle(color: Color(0xff060708)),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: const Color(0xff00d7f3),
          onPressed: () {
            setState(() {
              tasks.insert(position!, deletedTask!);
            });
          },
        ),
      ),
    );
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
            style: TextButton.styleFrom(foregroundColor: Color(0xff00d7f3)),
              child: Text('Cancelar'),
          ),
          TextButton(
              onPressed: (){
                setState(() {
                  tasks.clear();
                });
                Navigator.of(context).pop();
              },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Limpar tudo'),
          ),
        ],
      ),
    );
  }
}
