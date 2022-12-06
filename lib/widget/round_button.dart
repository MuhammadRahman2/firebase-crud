import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool? loading;
  RoundButton({required this.title, required this.onTap, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 300,
        decoration: BoxDecoration(
            color: Colors.purple, borderRadius: BorderRadius.circular(15)
            //  border:Border.all()
            ),
        child: Center(child: loading! ? const CircularProgressIndicator(color: Colors.white,) : Center(child: Text(title)),)          
            
      ),
    );
  }
}
