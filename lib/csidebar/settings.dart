import 'package:finalproject/sqlite/data_model.dart';
import 'package:finalproject/sqlite/database.dart';
// import 'package:finalproject/sqlite/database.dart';
import 'package:flutter/material.dart';
// import '../sqlite/create_account.dart';
import 'collapsible_sidebar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';


Future<DataModel> updateAccount(int id, String firstname, String lastname, String username, String password, String email) async {
  final response = await http.put(
    Uri.parse("https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users/$id"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'password': password,
      'email': email
    }),
  );

  if (response.statusCode == 200) {
    //print(response.statusCode); //to check if updated successfully
    return DataModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.statusCode);
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<DataModel> data = [];
  bool fetching = false;
  int currentIndex = 0;
  var formKey = GlobalKey<FormState>();
  List todos = <dynamic>[];

  late DB db;
  @override
  void initState() {
    super.initState();
    db = DB();
    // getData2();
    getTodo();
  }

  // void getData2() async {
  //   data = await db.getData();
  //   setState(() {
  //     fetching = false;
  //   });
  // }


  getTodo() async {
    var url = 'https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users';
    var response = await http.get(Uri.parse(url));

    setState( () {
      todos = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
  }

  deleteTodo(int id) async {
    var response = await http.delete(Uri.parse('https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users/$id'));

    if (response.statusCode == 200) {
      //print (response.statusCode); //to check if addTodo is success
    } else {
      throw Exception('${response.statusCode}: FAILED TO DELETED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Settings"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.add),
      ),
      body:
      // fetching
      //     ? const Center(
      //   child: CircularProgressIndicator(),
      // )
      //     :
      ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
          // return Form(
          //   key: formKey,
          //   child: ListView(
          //   padding: const EdgeInsets.all(20),
          //   children: [
          //     TextFormField(
          //       controller: firstNameController,
          //       keyboardType: TextInputType.name,
          //       decoration: const InputDecoration(
          //           labelText: "First Name"
          //       ),
          //       validator: (value){
          //         return (value == '')? "Input Name" : null;
          //       },
          //     ),
          //     const SizedBox(height: 10),
          //     TextFormField(
          //       controller: lastNameController,
          //       keyboardType: TextInputType.name,
          //       decoration: const InputDecoration(
          //           labelText: "Last Name"
          //       ),
          //       validator: (value){
          //         return (value == '')? "Input Name" : null;
          //       },
          //     ),
          //     const SizedBox(height: 10),
          //     TextFormField(
          //       controller: userNameController,
          //       keyboardType: TextInputType.name,
          //       decoration: const InputDecoration(
          //           labelText: "Username"
          //       ),
          //       validator: (value){
          //         return (value == '')? "Input Name" : null;
          //       },
          //     ),
          //     const SizedBox(height: 10),
          //     TextFormField(
          //       controller: passwordController,
          //       keyboardType: TextInputType.name,
          //       decoration: const InputDecoration(
          //           labelText: "Password"
          //       ),
          //       validator: (value){
          //         return (value == '')? "Input Name" : null;
          //       },
          //     ),
          //     const SizedBox(height: 10),
          //     TextFormField(
          //       controller: emailController,
          //       keyboardType: TextInputType.name,
          //       decoration: const InputDecoration(
          //           labelText: "Email Address"
          //       ),
          //       validator: (value){
          //         return (value == '')? "Input Name" : null;
          //       },
          //     ),
          //     const SizedBox(height: 10),
          //     ElevatedButton(
          //         onPressed: (){
          //
          //     },
          //         child: const Text("UPDATE")
          //     ),
          //     const SizedBox(height: 20),
          //     ElevatedButton(
          //         onPressed: (){
          //
          //         },
          //         child: const Text("DELETE")
          //     ),
          //   ]
            leading: IconButton(
                onPressed: (){
                  currentIndex = int.parse(todos[index]['id']);
                  popUpdate(currentIndex);
            },
                icon: const Icon(Icons.update)),
            title: Text('${todos[index]['id']} : ${todos[index]['username']}'),
            trailing: IconButton(
                onPressed: (){
                 int idNum = int.parse(todos[index]['id']);
                 setState(() {
                   todos.remove(todos[index]);
                 });
                deleteTodo(idNum);
            },
              icon: const Icon(Icons.delete)),
          );
        }
      ),
      drawer: const NavBar(),
    );
  }
  void popUpdate(int id) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: const EdgeInsets.all(14),
            content: Column(
                children: [
                  TextFormField(
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "First Name"
                      ),
                      validator: (value){
                        return (value == '')? "Input Name" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Last Name"
                      ),
                      validator: (value){
                        return (value == '')? "Input Name" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: userNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Username"
                      ),
                      validator: (value){
                        return (value == '')? "Input Name" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Password"
                      ),
                      validator: (value){
                        return (value == '')? "Input Name" : null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Email Address"
                      ),
                      validator: (value){
                        return (value == '')? "Input Name" : null;
                      },
                    )
                ],
              ),
            actions: [
              TextButton(
                onPressed: () {
                  // DataModel newData = todos[id];
                  // newData.firstname = firstNameController.text;
                  // newData.lastname = lastNameController.text;
                  // newData.username = userNameController.text;
                  // newData.password = passwordController.text;
                  // newData.email = emailController.text;
                  // db.update(newData, newData.id!);
                  setState(() {
                    updateAccount(
                        id,
                        firstNameController.text,
                        lastNameController.text,
                        userNameController.text,
                        passwordController.text,
                        emailController.text);
                  });
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          );
        });
  }

  // void edit(index) {
  //   currentIndex = index;
  //   firstNameController.text = data[index].firstname;
  //   lastNameController.text = data[index].lastname;
  //   userNameController.text = data[index].username;
  //   passwordController.text = data[index].password;
  //   emailController.text = data[index].email;
  //   popUpdate();
  // }

  // void delete(int index) {
  //   // db.delete(data[index].id!);
  //   setState(() {
  //     data.removeAt(index);
  //   });
  // }
}