import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_test/models/todo.dart';
import 'package:sqlite_test/pages/todo_widget.dart';
import 'package:sqlite_test/service/todo_db.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});
  @override
  State<TodosPage> createState() => TodosPageState();
}

class TodosPageState extends State<TodosPage> {
  List list = <String>['a', 'b', 'c', 'd', 'e', 'f', 'g'];
  List<Todo>? futureTodos;
  // late final Todo todos;
  final todoDB = ToDoDB();
  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  void fetchAll() {
    for (int i = 0; i < list.length; i++) {
      if (todoDB.fetchById(i) as Todo != null) {
        futureTodos?[i] = todoDB.fetchById(i) as Todo;
      }
    }
  }

  void fetchTodos(int id) {
    setState(() {
      futureTodos?[id] = todoDB.fetchById(id) as Todo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo List")),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(list[index]),
              subtitle: Text("${futureTodos?[index].title}"),
              //  FutureBuilder<Todo>(
              //     future: futureTodos,
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const Center(child: CircularProgressIndicator());
              //       } else {
              //         todos = snapshot.data!;
              //         final subtitle = DateFormat('yyyy-MM-dd hh:mm:ss').format(
              //             DateTime.parse(todos.updatedAt ?? todos.createAt!));
              //         return todos == null ? Text('No Todo') : Text(subtitle);
              //       }
              //     }),
              trailing: IconButton(
                  onPressed: () async {
                    await todoDB.delete(index);
                    fetchTodos(index);
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete)),
              onTap: () async {
                // Todo node =
                //     await todoDB.fetchById(todo.id, todo.title);
                showDialog(
                  context: context,
                  builder: (context) =>
                      // AlertDialog(title: Text(node.createAt))
                      CreateTodoWidget(
                    todo: futureTodos?[index] ?? null,
                    onSubmit: (value) async {
                      futureTodos?[index] == null
                          ? await todoDB.create(title: value)
                          : await todoDB.update(id: index, title: value);
                      fetchTodos(index);
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: list.length),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     showDialog(
      //       context: context,
      //       builder: (context) => CreateTodoWidget(
      //         onSubmit: (title) async {
      //           await todoDB.create(title: title);
      //           if (!mounted) return;
      //           fetchTodos();
      //           Navigator.pop(context);
      //         },
      //       ),
      //     );
      //   },
      // ),
    );
  }
}



// class TodosPageState extends State<TodosPage> {
//   Future<List<Todo>>? futureTodos;
//   final todoDB = ToDoDB();
//   @override
//   void initState() {
//     super.initState();
//     fetchTodos();
//   }

//   void fetchTodos() {
//     setState(() {
//       futureTodos = todoDB.fetchAll();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Todo List")),
//       body: FutureBuilder<List<Todo>>(
//         future: futureTodos,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             final todos = snapshot.data!;
//             return todos.isEmpty
//                 ? const Center(
//                     child: Text('No Todos'),
//                   )
//                 : ListView.separated(
//                     itemBuilder: (context, index) {
//                       final subtitle = DateFormat('yyyy-MM-dd hh:mm:ss').format(
//                           DateTime.parse(todos[index].updatedAt ?? todos[index].createAt));
//                       return ListTile(
//                         title: Text(todos[index].title),
//                         subtitle: Text(subtitle),
//                         trailing: IconButton(
//                             onPressed: () async {
//                               await todoDB.delete(todos[index].id);
//                               fetchTodos();
//                             },
//                             icon: const Icon(Icons.delete)),
//                         onTap: () async {
//                           // Todo node =
//                           //     await todoDB.fetchById(todo.id, todo.title);
//                           showDialog(
//                             context: context,
//                             builder: (context) =>
//                                 // AlertDialog(title: Text(node.createAt))
//                                 CreateTodoWidget(
//                               todo: todos[index],
//                               onSubmit: (value) async {
//                                 await todoDB.update(id: todos[index].id, title: value);
//                                 fetchTodos();
//                                 if (!mounted) return;
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     separatorBuilder: (context, index) => const Divider(),
//                     itemCount: todos.length);
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) => CreateTodoWidget(
//               onSubmit: (title) async {
//                 await todoDB.create(title: title);
//                 if (!mounted) return;
//                 fetchTodos();
//                 Navigator.pop(context);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


  //List<String> list = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];
  // ListView.separated(
  //             itemBuilder: (context, index) {
  //               return ListTile(
  //                 title: Text(list[index]),
  //                 subtitle: FutureBuilder<Todo>(
  //                     future: futureTodos,
  //                     builder: (context, snapshot) {
  //                       if (snapshot.connectionState ==
  //                           ConnectionState.waiting) {
  //                         return const Center(
  //                             child: CircularProgressIndicator());
  //                       } else {
  //                         todo = snapshot.data!;
  //                         final subtitle = DateFormat('yyyy-MM-dd hh:mm:ss')
  //                             .format(DateTime.parse(
  //                                 todo.updatedAt ?? todo.createAt));
  //                         return Text(
  //                             todo != null ? "${todo.title} : $subtitle" : "");
  //                       }
  //                     }),
  //                 trailing: IconButton(
  //                     onPressed: () async {
  //                       await todoDB.delete(todo.id);
  //                       fetchTodos(todo.id);
  //                     },
  //                     icon: const Icon(Icons.delete)),
  //                 onTap: () async {
  //                   // Todo node =
  //                   //     await todoDB.fetchById(todo.id, todo.title);
  //                   showDialog(
  //                     context: context,
  //                     builder: (context) =>
  //                         // AlertDialog(title: Text(node.createAt))
  //                         CreateTodoWidget(
  //                       todo: todo.createAt == null ? null : todo,
  //                       onSubmit: (value) async {
  //                         todo.createAt == null
  //                             ? await todoDB.create(title: value)
  //                             : await todoDB.update(id: todo.id, title: value);
  //                         fetchTodos(todo.id);
  //                         if (!mounted) return;
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //             separatorBuilder: (context, index) => const Divider(),
  //             itemCount: list.length),
