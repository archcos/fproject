import 'package:finalproject/csidebar/collapsible_sidebar.dart';
import 'package:finalproject/sqlite/create_post.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences logindata;
  late String username;

  List posts = <dynamic>[];

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  getPosts() async {
    var url = 'https://63c95a0e320a0c4c9546afb1.mockapi.io/api/posts';
    var response = await http.get(Uri.parse(url));

    setState( () {
      posts = convert.jsonDecode(response.body) as List<dynamic>;
    }
    );
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }


  @override void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Expanded(
                  flex: 1,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        icon: Icon(
                          Icons.search,
                          color: Colors.white54,
                        )
                    ),
                  ),
                ),
              ],
            ),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text("Home"),
                ),
                Tab(
                  child: Text("Popular"),
                ),
              ],
            ),
          ),
          drawer: const NavBar(),
          body: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: CircleAvatar(
                    child: ClipOval(
                      child:
                      Image.network('${posts[index]['avatar']}',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90
                      ),
                    ),
                  ),
                  title: Text('${posts[index]['message']}'),
                  subtitle: Text('${posts[index]['user']} - ${posts[index]['createdAt']}'),
                );
              }
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePost())
              );
            },
            child: const Icon(Icons.add),
          ),
        )
    );
  }
}
