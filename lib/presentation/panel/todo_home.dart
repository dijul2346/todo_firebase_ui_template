import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_ui_template/core/core.dart';
import 'package:todo_firebase_ui_template/domain/infrastructure/todo_db.dart';
import 'package:todo_firebase_ui_template/domain/todo_model.dart';

class ScreenTodoHome extends StatefulWidget {
  const ScreenTodoHome({super.key});

  @override
  State<ScreenTodoHome> createState() => _ScreenTodoHomeState();
}

class _ScreenTodoHomeState extends State<ScreenTodoHome> {
  List<TodoModel> todoModelList = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final taskController = TextEditingController();
  final taskSearchController = TextEditingController();
  String userName = '';
  bool editFlag = false;
  int index = 100;
  String editId = '';
  @override
  Widget build(BuildContext context) {
    loadUserName();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome $userName',
          style: TextStyle(fontSize: 23, color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .16,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, right: 24),
                              child: TextFormField(
                                controller: taskController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Task Cannot be empty!';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Search Task here..',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)))),
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, // Text color
                              backgroundColor:
                                  Colors.purple, // Button background color
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (editFlag == false) {
                                  index = index + 1;
                                  TodoModel t = TodoModel(
                                      id: 'id',
                                      userId: 'userId',
                                      todoName: taskController.text,
                                      todoStatus: '0');
                                  addTask(t);

                                  taskController.text = '';
                                } else {
                                  setState(() {
                                    editFlag = false;
                                    for (var doc in todoModelList) {
                                      if (doc.id == editId) {
                                        doc.todoName = taskController.text;
                                      }
                                    }
                                  });
                                }
                              }
                            },
                            child: Text(editFlag == false ? 'Add' : 'Save'),
                          )
                        ],
                      ),
                      Visibility(
                        visible: editFlag,
                        child: Row(
                          children: [
                            const Spacer(),
                            TextButton(
                                onPressed: () {
                                  taskController.text = '';
                                },
                                child: const Text('Cancel Edit')),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {},
                      leading: Text(
                        (index + 1).toString(),
                        style: const TextStyle(fontSize: 19),
                      ),
                      title: Text(
                        todoModelList[index].todoName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            const Text(
                              'Status-',
                              style: TextStyle(color: Colors.purple),
                            ),
                            Icon(
                              todoModelList[index].todoStatus == '0'
                                  ? Icons.pending_actions_rounded
                                  : Icons.verified,
                              color: todoModelList[index].todoStatus == '0'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  taskController.text =
                                      todoModelList[index].todoName;
                                  setState(() {
                                    editFlag = true;
                                    editId = todoModelList[index].id;
                                  });
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  deleteTask(todoModelList[index].id);
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: todoModelList.length),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadUserName() async {
    globalusername = await getUserName(globalUserId);
    await loadDatabase();
    setState(() {
      userName = globalusername;
      todoModelList = globalTodoList;
    });
  }
}

Future<void> deleteTask(String taskId) async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(taskId)
      .delete()
      .then((_) {
    loadDatabase();
  });
}
