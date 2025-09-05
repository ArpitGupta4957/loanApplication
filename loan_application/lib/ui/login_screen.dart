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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
              Color(0xFF43E97B),
              Color(0xFFFF6A00),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_circle, size: 80, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Color(0xFF2575FC),
                          ),
                          labelText: 'Mobile Number',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => setState(() => mobile = v),
                      ),
                      SizedBox(height: 16),
                      if (!otpSent)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Color(0xFF2575FC),
                              elevation: 6,
                            ),
                            icon: Icon(Icons.send, color: Colors.white),
                            label: Text(
                              'Send OTP',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: _sendOtp,
                          ),
                        ),
                      if (otpSent && !otpVerified)
                        Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(0xFF43E97B),
                                ),
                                labelText: 'Enter OTP',
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.9),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => setState(() => otp = v),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: Color(0xFF43E97B),
                                  elevation: 6,
                                ),
                                icon: Icon(Icons.verified, color: Colors.white),
                                label: Text(
                                  'Verify',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: _verifyOtp,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 24),
                      Text(
                        'Or use:',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: Color(0xFF6A11CB),
                              elevation: 4,
                            ),
                            icon: Icon(
                              Icons.fingerprint,
                              color: Colors.white,
                              size: 28,
                            ),
                            label: Text(''),
                            onPressed: _authenticateWithFingerprint,
                          ),
                          SizedBox(width: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(16),
                              backgroundColor: Color(0xFFFF6A00),
                              elevation: 4,
                            ),
                            icon: Icon(
                              Icons.face,
                              color: Colors.white,
                              size: 28,
                            ),
                            label: Text(''),
                            onPressed: _authenticateWithFace,
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        icon: Icon(Icons.person_add, color: Colors.white),
                        label: Text('Register as New User'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
