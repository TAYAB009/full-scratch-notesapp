import 'package:dbversion3/add_user.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MaterialApp(
    title: 'Database version-3',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      //print('User id is $dbResult');
    } else {
      print('user not inserted');
    }

    return dbResult;
  }

  Future<List<User>> getAllUsers() async {
    await dbHandler.initDatabase();
    final fetchedUsers = await dbHandler.getAllUsers();
    //print('number of users are: ${fetchedUsers.length}');
    //print(fetchedUsers[0].id);
    // for (var user in fetchedUsers) {
    //   print('id: ${user.id}... Name: ${user.name}....Age: ${user.age}');
    // }
    return fetchedUsers;
  }

  @override
  void initState() {
    dbHandler = DatabaseHandler();
    userList = [user1, user2, user3];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getAllUsers();
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AddUser();
                    },
                  ));
                },
                child: const Icon(Icons.done, color: Colors.black))
          ],
          title: const Text('DB version-3'),
        ),
        body: FutureBuilder(
          future: dbHandler.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].id.toString()),
                      subtitle: TextButton(
                          onPressed: () {
                            print(snapshot.data![index].id);
                          },
                          child: const Text('ID')),
                      trailing: IconButton(
                          onPressed: () {
                            final id = snapshot.data![index].id;
                            setState(() {
                              print(id);
                              dbHandler.deleteUser(id!);
                            });
                          },
                          icon: const Icon(Icons.delete)),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class User {
  int? id;
  final String name;
  final int age;
  User(this.name, this.age);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        age = json['age'];

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}

class DatabaseHandler {
  Future<Database> initDatabase() async {
    final dbpath = await getDatabasesPath();
    String databaseName = 'users.db';
    final path = join(dbpath, databaseName);
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)");
        var result = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'users' ");
        if (result.isNotEmpty) {
          print('table users created..........showing database created');
        } else {
          print('faild to create database');
        }
      },
    );
    return database;
  }

  Future<int> deleteUser(int id) async {
    Database database = await initDatabase();
    final delUseRes =
        database.delete('users', where: 'id = ?', whereArgs: [id]);
    print('Row ${id} affected');
    return delUseRes;
  }

  Future<int> insertUser(List<User> users) async {
    Database database = await initDatabase();
    int result = 0;
    for (var user in users) {
      result = await database.insert('users', user.toJson());
    }
    return result;
  }

  Future<List<User>> getAllUsers() async {
    Database database = await initDatabase();
    final queryResult = await database.query('users', orderBy: 'id DESC');
    final result = queryResult.map((users) => User.fromJson(users)).toList();

    return result;
  }
}
