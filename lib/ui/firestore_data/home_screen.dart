// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_practices/ui/auth/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'add_data.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final auth = FirebaseAuth.instance;
//   final db = FirebaseFirestore.instance.collection('post').snapshots();
//   CollectionReference collectionReference =
//       FirebaseFirestore.instance.collection('post');
//   final searchController = TextEditingController();
//   final editController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         SystemNavigator.pop();
//         return true;
//       },
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Home firestore'),
//             actions: [
//               InkWell(
//                   onTap: () {
//                     auth.signOut().then((value) => {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) {
//                               return LoginScreen();
//                             },
//                           ))
//                         });
//                   },
//                   child: const Icon(
//                     Icons.logout_outlined,
//                     size: 25,
//                   )),
//               const SizedBox(
//                 width: 15,
//               )
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (context) {
//                   return AddData();
//                 },
//               ));
//             },
//             child: const Icon(Icons.add),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: searchController,
//                   decoration: const InputDecoration(
//                       hintText: 'search', border: OutlineInputBorder()),
//                   onChanged: (value) {
//                     setState(() {
//                       // value = searchController.text;
//                     });
//                   },
//                 ),
//                 Expanded(
//                     child: StreamBuilder<QuerySnapshot>(
//                   stream: db,
//                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (!snapshot.hasData) {
//                       return CircularProgressIndicator();
//                     } else {
//                       return ListView.builder(
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//                             final title =
//                                 snapshot.data!.docs[index]['title'].toString();
//                             if (searchController.text.isEmpty) {
//                               return ListTile(
//                                 title: Text(title),
//                                 subtitle: Text(
//                                     snapshot.data!.docs[index].id.toString()),
//                                 trailing: PopupMenuButton(
//                                   itemBuilder: (context) {
//                                     return [
//                                       PopupMenuItem(
//                                         child: ListTile(
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                             showMyDialog(
//                                                 title,
//                                                 snapshot.data!.docs[index].id
//                                                     .toString());
//                                           },
//                                           leading: const Icon(Icons.edit),
//                                           title: const Text('Edit'),
//                                         ),
//                                       ),
//                                       PopupMenuItem(
//                                         child: ListTile(
//                                           onTap: () {
//                                             Navigator.pop(context);
//                                             collectionReference
//                                                 .doc(snapshot
//                                                     .data!.docs[index].id
//                                                     .toString())
//                                                 .delete();
//                                           },
//                                           leading: const Icon(Icons.delete),
//                                           title: const Text('Delete'),
//                                         ),
//                                       ),
//                                     ];
//                                   },
//                                 ),
//                               );
//                             } else if (title.toLowerCase().contains(
//                                 searchController.text.toLowerCase())) {
//                               return ListTile(
//                                 title: Text(title),
//                                 subtitle: Text(
//                                     snapshot.data!.docs[index].id.toString()),
//                               );
//                             } else {
//                               return Container();
//                             }
//                           });
//                     }
//                   },
//                 )),
//               ],
//             ),
//           )),
//     );
//   }

//   Future<void> showMyDialog(String title, String id) async {
//     editController.text = title;
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Icon(Icons.edit),
//           content: TextField(
//             controller: editController,
//             decoration: const InputDecoration(hintText: 'Edit'),
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Cancel')),
//             TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   collectionReference
//                       .doc(id)
//                       .update({'title': editController.text.toString()});
//                 },
//                 child: const Text('Add')),
//           ],
//         );
//       },
//     );
//   }
// }
