import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data_model.dart';
import 'dart:convert';

Future<DataModel> postAccount( int? id, String firstname, String lastname, String username, String password, String email) async {
  final response = await http.post(
    Uri.parse("https://63c8e7d6c3e2021b2d4b8ffb.mockapi.io/users"),
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

  if (response.statusCode == 201) {
    //print (response.statusCode); //to check if addTodo is success
    return DataModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Add Todo');
  }
}

class DataCard extends StatelessWidget {
  const DataCard({
    Key? key,
    required this.data,
    required this.edit,
    required this.index,
    required this.delete,
  }) : super(key: key);
  final DataModel data;
  final Function edit;
  final Function delete;

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: IconButton(
              onPressed: () {
                edit(index);
              },
              icon: const Icon(Icons.edit)),
        ),
        title: Text(data.username),
        subtitle: Text(data.password),
        trailing: CircleAvatar(
            backgroundColor: Colors.red,
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                delete(index);
              },
            )),
      ),
    );
  }
}
