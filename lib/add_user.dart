import 'package:dbversion3/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late DatabaseHandler databaseHandler;
  List<User> userList = [];
  @override
  void initState() {
    databaseHandler = DatabaseHandler();
    databaseHandler.initDatabase();
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User Page'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter user name',
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter user age',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10.0),
            TextButton(
                onPressed: () {
                  setState(() {
                    //databaseHandler.insertUser(nameController.text);
                  });
                },
                child: const Text('Add User'))
          ],
        ),
      ),
    );
  }
}
