import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../../widget/round_button.dart';

class AddData extends StatefulWidget {
  AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController postController = TextEditingController();

  bool loading = false;

  final ref = FirebaseDatabase.instance.ref('post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post data'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: postController,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: 'add Data',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: 'Add Data',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                   final id = DateTime.now().millisecondsSinceEpoch.toString();
                    ref.child(id).set({
                      'id': id,
                      'title': postController.text.toString()
                    }).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage('success');
                    });
                  })
            ],
          ),
        ));
  }
}
