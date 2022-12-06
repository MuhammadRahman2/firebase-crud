import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practices/ui/auth/verification_code_secreen.dart';
import 'package:firebase_practices/utils/utils.dart';
import 'package:firebase_practices/widget/round_button.dart';
import 'package:flutter/material.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final phoneController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Phone Auth'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+9212345678',
                  helperText: 'make sure you put +92 other not accept'
                  ),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: 'Phone Auth',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    auth.verifyPhoneNumber(
                      phoneNumber: phoneController.text.toString(),
                      verificationCompleted: (_) {
                         setState(() {
                      loading = false;
                    });
                      },
                      verificationFailed: (e) {
                        setState(() {
                      loading = false;
                    });
                        Utils().toastMessage(e.toString());
                      },
                      codeSent: (String verificationId, int? token) {
                         setState(() {
                      loading = false;
                    });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => VerificationCodeSeceen(
                                      verifyCode: verificationId,
                                    )));
                      },
                      codeAutoRetrievalTimeout: (e) {
                         setState(() {
                      loading = false;
                    });
                        Utils().toastMessage(e.toString());
                      },
                    );
                  })
            ],
          ),
        ));
  }
}
