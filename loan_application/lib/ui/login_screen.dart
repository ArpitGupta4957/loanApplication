import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'home_dashboard_screen.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String mobile = '';
  String otp = '';
  String sentOtp = '';
  bool otpSent = false;
  bool otpVerified = false;
  final LocalAuthentication auth = LocalAuthentication();

  void _sendOtp() {
    sentOtp = (1000 + (9999 * mobile.hashCode % 9000)).toString();
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
          MaterialPageRoute(builder: (context) => HomeDashboardScreen()),
        );
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid OTP!')));
    }
  }

  Future<void> _authenticateWithFingerprint() async {
    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (didAuthenticate) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeDashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fingerprint not matched!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fingerprint authentication failed: $e')),
      );
    }
  }

  Future<void> _authenticateWithFace() async {
    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate with Face ID',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (didAuthenticate) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeDashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Face not matched!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Face authentication failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                onChanged: (v) => setState(() => mobile = v),
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
              SizedBox(height: 16),
              Text('Or use:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.fingerprint),
                    onPressed: _authenticateWithFingerprint,
                  ),
                  IconButton(
                    icon: Icon(Icons.face),
                    onPressed: _authenticateWithFace,
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationScreen(),
                    ),
                  );
                },
                child: Text('Register as New User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
