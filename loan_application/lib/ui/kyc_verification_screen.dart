import 'package:flutter/material.dart';
import 'underwriting_screen.dart';

class KYCVerificationScreen extends StatelessWidget {
  final bool isVerified;
  const KYCVerificationScreen({super.key, this.isVerified = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KYC Verification and Document Check')),
      body: Center(
        child: isVerified
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified, color: Colors.green, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'KYC Verified and Documents Checked!',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UnderwritingScreen(),
                        ),
                      );
                    },
                    child: Text('Proceed to Underwriting'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'KYC Verification Failed',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.mic),
                    label: Text('Voice Feedback'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
      ),
    );
  }
}
