import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practices/utils/utils.dart';
import 'package:flutter/material.dart';
import '../firestore_data/home_screen.dart';
import '../realtime_database/home_screen.dart';
import '../../widget/round_button.dart';

class VerificationCodeSeceen extends StatefulWidget {
  VerificationCodeSeceen({required this.verifyCode});
  String verifyCode;

  @override
  State<VerificationCodeSeceen> createState() => _VerificationCodeSeceenState();
}

class _VerificationCodeSeceenState extends State<VerificationCodeSeceen> {
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
          title: const Text('verifycode'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(hintText: 'code'),
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                  title: 'verify ',
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verifyCode,
                        smsCode: phoneController.text.toString());

                    try {
                      await auth.signInWithCredential(credential).then((value) {
                        setState(() {
                      loading = false;
                    });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      });
                    } catch (e) {
                      setState(() {
                      loading = false;
                    });
                      Utils().toastMessage(e.toString());
                    }
                  })
            ],
          ),
        ));
    ;
  }
}
