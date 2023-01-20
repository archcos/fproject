
import 'package:flutter/material.dart';
import 'sqlite/data_model.dart';
import 'sqlite/database.dart';
import 'sqlite/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert' as convert;

Future<DataModel> postAccount(int? id, String firstname, String lastname, String username, String password, String email) async {
  final response = await http.post(
    Uri.parse("https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<dynamic, dynamic>{
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'password': password,
      'email': email
    }),
  );

  if (response.statusCode == 201) {
    return DataModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Add Todo');
  }
}
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  late SharedPreferences logindata;
  late bool newuser;
  List todos = <dynamic>[];
  var formKey = GlobalKey<FormState>();
  List<DataModel> data = [];
  bool fetching = true;
  late var currentIndex;
  // bool _obscureText = true;

  // String? _password;
  //
  // void _toggle() {
  //   setState(() {
  //     _obscureText = !_obscureText;
  //   });
  // }

  late DB db;

  @override
  void initState() {
    super.initState();
    db = DB();
    db.initDB();
    checkPermission();
    getUsers();
    // getData2();
  }

  checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();
    statuses[Permission.storage];
  }


  getUsers() async {
    var url = 'https://63c95a0e320a0c4c9546afb1.mockapi.io/api/users';
    var response = await http.get(Uri.parse(url));

    setState( () {
      todos = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
  }



  // void getData2() async {
  //   data = await db.getData();
  //   setState(() {
  //     fetching = false;
  //   });
  // }
  //
  // void check_if_already_login() async {
  //   logindata = await SharedPreferences.getInstance();
  //   newuser = (logindata.getBool('login') ?? true);
  //
  //   print(newuser);
  //   if (newuser == false) {
  //     Navigator.pushReplacement(
  //         context, new MaterialPageRoute(builder: (context) => HomePage()));
  //   }
  // }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.handshake),
          title: const Text("KoneK"),
        ),
        body: Form(
            key: formKey,
            child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
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
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      )
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()
                            )
                        );
                      },
                      child: const Text("Log In")
                  ),
                  TextButton(
                      onPressed: (){
                        showMyDialogue();
                      },
                      child: const Text("Create Account")
                  )
                ]
            )
        )
    );
  }

  void showMyDialogue() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Create Account'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "First Name"),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Last Name"),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: userNameController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Username"),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: "Password"),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "Email Address"),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  currentIndex = todos.lastIndexOf('id', 0);
                  DataModel dataLocal = DataModel(
                    firstname: firstNameController.text,
                    lastname: lastNameController.text,
                    username: userNameController.text,
                    password: passwordController.text,
                    email: emailController.text,
                  );
                  db.insertData(dataLocal);
                  setState(() {
                    postAccount(
                      currentIndex,
                      firstNameController.text,
                      lastNameController.text,
                      userNameController.text,
                      passwordController.text,
                      emailController.text
                    );
                  });
                  firstNameController.clear();
                  lastNameController.clear();
                  userNameController.clear();
                  passwordController.clear();
                  emailController.clear();
                },
                child: const Center(
                  child: Text("Sign Up"),
                ),
              ),
            ],
          );
        });
  }
}