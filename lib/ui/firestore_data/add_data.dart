// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_practices/ui/utils/utils.dart';
// import 'package:firebase_practices/ui/widget/round_button.dart';
// import 'package:flutter/material.dart';

// class AddData extends StatefulWidget {
//   AddData({super.key});

//   @override
//   State<AddData> createState() => _AddDataState();
// }

// class _AddDataState extends State<AddData> {
//   TextEditingController postController = TextEditingController();

//   bool loading = false;

//   // final ref = FirebaseDatabase.instance.ref('post');
//   final db = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Post data'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: postController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                     hintText: 'add Data',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10))),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               RoundButton(
//                   title: 'Add Data',
//                   loading: loading,
//                   onTap: () {
//                     setState(() {
//                       loading = true;
//                     });
//                     final id = DateTime.now().millisecondsSinceEpoch.toString();
//                     db.collection('post').doc(id).set({
//                       'id': id,
//                       'title': postController.text.toString()
//                     }).then((value) {
//                       setState(() {
//                         loading = false;
//                       });
//                       Utils().toastMessage('data add');
//                     });
//                     // or 
//                     db.collection('user').add({
//                       'id': id,
//                       'title': postController.text.toString()
//                     }).then((value) {
//                       setState(() {
//                         loading = false;
//                       });
//                       Utils().toastMessage('data add');
//                     });

//                     // ref.child(id).set({
//                     //   'id': id,
//                     //   'title': postController.text.toString()
//                     // }).then((value) {
//                     //   setState(() {
//                     //     loading = false;
//                     //   });
//                     //   Utils().toastMessage('success');
//                     // });
//                   })
//             ],
//           ),
//         ));
//   }
// }
