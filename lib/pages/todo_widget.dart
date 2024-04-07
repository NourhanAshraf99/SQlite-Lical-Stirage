import 'package:flutter/material.dart';
import 'package:sqlite_test/models/todo.dart';

class CreateTodoWidget extends StatefulWidget {
  final Todo? todo;
  final ValueChanged<String> onSubmit;

  const CreateTodoWidget({super.key, this.todo, required this.onSubmit});

  @override
  State<CreateTodoWidget> createState() => CreateTodoWidgetState();
}

class CreateTodoWidgetState extends State<CreateTodoWidget> {
  final controller = TextEditingController();
  final fromkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    controller.text = widget.todo?.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    return AlertDialog(
      title: Text(isEditing ? "Edit Todo" : "Add Todo"),
      content: Form(
        key: fromkey,
        child: TextFormField(
          autofocus: true,
          controller: controller,
          decoration: const InputDecoration(hintText: 'Title'),
          validator: (value) =>
              value != null && value.isEmpty ? 'title required' : null,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('cancel')),
        TextButton(
            onPressed: () {
              if (fromkey.currentState!.validate()) {
                widget.onSubmit(controller.text);
              }
            },
            child: const Text('done'))
      ],
    );
  }
}
