import 'package:flutter/material.dart';
import 'document_upload_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String mobile = '';
  String otp = '';
  String sentOtp = '';
  bool otpSent = false;
  bool otpVerified = false;

  void _sendOtp() {
    // Simulate sending OTP
    sentOtp = (1000 + (9999 * (name.hashCode + mobile.hashCode) % 9000))
        .toString();
    setState(() {
      otpSent = true;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('OTP sent to $mobile: $sentOtp')));
  }

  void _verifyOtp() {
    if (otp == sentOtp) {
      setState(() {
        otpVerified = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('OTP Verified!')));
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DocumentUploadScreen()),
        );
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid OTP!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Full Legal Name'),
                  onChanged: (v) => setState(() => name = v),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age (optional)'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => setState(() => mobile = v),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address/Pincode'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email ID (optional)'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                if (!otpSent)
                  ElevatedButton(onPressed: _sendOtp, child: Text('Send OTP')),
                if (otpSent && !otpVerified)
                  Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Enter OTP'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() => otp = v),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _verifyOtp,
                        child: Text('Verify'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
