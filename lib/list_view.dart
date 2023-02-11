import 'package:dbversion3/main.dart';
import 'package:flutter/material.dart';

class ListView extends StatefulWidget {
  const ListView({super.key});

  @override
  State<ListView> createState() => _ListViewState();
}

class _ListViewState extends State<ListView> {
  late DatabaseHandler dbHandler;
  late User user1 = User('TAYAB', 20);
  late User user2 = User('ktk', 30);
  late User user3 = User('IJ', 27);
  List<User> userList = [];

  Future<int> insertUser() async {
    await dbHandler.initDatabase();
    final dbResult = await dbHandler.insertUser(userList);
    if (dbResult > 0) {
      print('User inserted');
      print('User id is $dbResult');
    } else {
      print('user not inserted');
    }

    return dbResult;
  }

  Future<List<User>> getAllUsers() async {
    await dbHandler.initDatabase();
    final fetchedUsers = await dbHandler.getAllUsers();
    print('number of users are: ${fetchedUsers.length}');
    print(fetchedUsers[0].id);
    for (var user in fetchedUsers) {
      print('id: ${user.id}... Name: ${user.name}....Age: ${user.age}');
    }
    return fetchedUsers;
  }

  @override
  void initState() {
    dbHandler = DatabaseHandler();
    userList = [user1, user2, user3];
    insertUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
    );
  }
}
