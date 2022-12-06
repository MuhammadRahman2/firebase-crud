import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_works/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth/login_screen.dart';
import 'add_data.dart';

class HomeScreen extends StatefulWidget {
  String? name;
  String? url;
  HomeScreen({super.key, this.name, this.url});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('post');
  final searchController = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              InkWell(
                  onTap: () {
                    auth.signOut().then((value) => {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ))
                        });
                  },
                  child: const Icon(
                    Icons.logout_outlined,
                    size: 25,
                  )),
              const SizedBox(
                width: 15,
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return AddData();
                },
              ));
            },
            child: const Icon(Icons.add),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: FirebaseAnimatedList(
                      query: ref,
                      itemBuilder: (context, snapshot, animation, index) {
                        final id = snapshot.child('id').value.toString();
                        final name = snapshot.child('name').value.toString();
                        final imageUrl =
                            snapshot.child(widget.url.toString()).value.toString();
                        // if (imageUrl == auth.currentUser!.photoURL) {
                        //   return ListTile(
                        //       leading: CircleAvatar(
                        //         backgroundImage: NetworkImage(imageUrl),
                        //       ),
                        //       title: Text(id));
                        // } else {
                          return Container(
                            child: Text(name),
                          );
                        // }
                      },
                    )),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {},
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: searchController,
                  decoration: const InputDecoration(
                      hintText: 'search', border: OutlineInputBorder()),
                  onChanged: (value) {
                    setState(() {
                      // value = searchController.text;
                    });
                  },
                ),
                // Expanded(child: StreamBuilder(
                //   stream: ref.onValue,
                //   builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
                //     if(!snapshot.hasData){
                //           return CircularProgressIndicator();
                //         }else{
                //           return ListView.builder(
                //       itemCount: snapshot.data!.snapshot.children.length,
                //       itemBuilder: (context, index) {
                //           Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic ;
                //           List<dynamic> list = [];
                //           list.clear;
                //           list = map.values.toList();
                //           return ListTile(
                //           title: Text(list[index]['title']),
                //       );
                //     });
                //         }
                //   },
                // )),
                // // method 2
                Expanded(
                  child: FirebaseAnimatedList(
                    query: ref,
                    itemBuilder: (context, snapshot, animation, index) {
                      final title = snapshot.child('title').value.toString();
                      final id = snapshot.child('id').value.toString();
                      final image = snapshot.child('image').value.toString();
                      if (searchController.text.isEmpty) {
                        return ListTile(
                            title: Text(title),
                            subtitle: Text(id),
                            trailing: PopupMenuButton(
                              child: const Icon(Icons.more_horiz),
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(
                                          title,
                                          id,
                                        );
                                      },
                                      leading: const Icon(Icons.edit),
                                      title: const Text('Edit'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                      child: ListTile(
                                    onTap: () {
                                      ref
                                          .child(snapshot
                                              .child('id')
                                              .value
                                              .toString())
                                          .remove();
                                    },
                                    leading: const Icon(Icons.delete),
                                    title: const Text('delete'),
                                  ))
                                ];
                              },
                            ));
                        // for searching text
                      } else if (title
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                        return ListTile(
                          title: Text(snapshot.child('title').value.toString()),
                          subtitle: Text(snapshot.child('id').value.toString()),
                          trailing: InkWell(
                              onTap: () {}, child: const Icon(Icons.menu)),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('update'),
            content: Container(
                child: TextField(
              controller: editController,
              decoration: const InputDecoration(hintText: 'edit'),
            )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref
                        .child(id)
                        .update({'title': editController.text}).then((value) {
                      Utils().toastMessage('Value is update');
                    });
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}
