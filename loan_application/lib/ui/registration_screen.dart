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
                      Icon(Icons.person_add, size: 80, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Create Account',
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
                            Icons.person,
                            color: Color(0xFF2575FC),
                          ),
                          labelText: 'Full Legal Name *',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onChanged: (v) => setState(() => name = v),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.cake,
                            color: Color(0xFFFF6A00),
                          ),
                          labelText: 'Age (optional)',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Color(0xFF2575FC),
                          ),
                          labelText: 'Mobile Number *',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => setState(() => mobile = v),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(v.trim())) {
                            return 'Enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.home,
                            color: Color(0xFF43E97B),
                          ),
                          labelText: 'Address/Pincode *',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Address is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFF6A11CB),
                          ),
                          labelText: 'Email ID (optional)',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
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
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _sendOtp();
                              }
                            },
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
