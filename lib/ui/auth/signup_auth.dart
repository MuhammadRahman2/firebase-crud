import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practices/ui/auth/login_screen.dart';
import 'package:firebase_practices/ui/auth/phone_auth.dart';
import 'package:firebase_practices/ui/realtime_database/home_screen.dart';
import 'package:firebase_practices/utils/utils.dart';
import 'package:firebase_practices/widget/round_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final database = FirebaseDatabase.instance.ref('post');
  final storage = FirebaseStorage.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp() {
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getImagePicker();
              },
              child: Container(
                child: imageFile == null
                    ? const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.yellow,
                        child: Text('select image'),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(imageFile!.absolute)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                     TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: nameController,
                      decoration: const InputDecoration(
                          hintText: 'name',
                          prefixIcon: Icon(Icons.person)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter name';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_open)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        } else if (value.length < 6) {
                          return 'Your password less then 6';
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
              title: 'Sign up',
              loading: loading,
              onTap: () async {
               
                if (_formKey.currentState!.validate()) {

                  setState(() {
                    loading = true;
                  });
                  try {
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final imageRef = storage.ref('/image/'+ id);
                final uploadTask = imageRef.putFile(imageFile!.absolute);
                await Future.value(
                    uploadTask); //image will upload in firebase storege
                // for image url show
                var newUrl = await imageRef.getDownloadURL();
                // image store in real time database firebase
                database.child(id).set({
                  'id': id,
                    'name': nameController.text.toString(),
                   'image': newUrl.toString()
                   });

                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text.toString(),
                      password: passwordController.text.toString(),
                    )
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen(name: nameController.text,url: newUrl,);
                        },
                      ));
                      // Utils()
                      //     .toastMessage('The password provided is too weak.');
                    });
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      loading = false;
                    });
                    if (e.code == 'weak-password') {
                      // print('The password provided is too weak.');
                      Utils().toastMessage(
                          'success but ,The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      // print('The account already exists for that email.');
                      Utils().toastMessage(
                          'sorry! The account already exists for that email.');
                    }
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    // print(e);
                    Utils().toastMessage(e.toString());
                  }
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhoneAuthScreen()));
                },
                child: const Text('Phone Authentication')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("you have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text('login'))
              ],
            )
          ],
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  Future<void> getImagePicker() async {
    final pickImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickImage != null) {
      setState(() {
        imageFile = File(pickImage.path);
      });
    }
  }
}
