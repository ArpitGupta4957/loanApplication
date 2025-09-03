import 'package:flutter/material.dart';
import 'kyc_verification_screen.dart';

class LoanApplicationScreen extends StatelessWidget {
  const LoanApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply for Loan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Type of Loan'),
              items: [
                DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                DropdownMenuItem(value: 'Business', child: Text('Business')),
                DropdownMenuItem(value: 'Education', child: Text('Education')),
              ],
              onChanged: (value) {},
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount (₹)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Tenure (months)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(decoration: InputDecoration(labelText: 'Purpose')),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        KYCVerificationScreen(isVerified: true),
                  ),
                );
              },
              child: Text('Submit Loan Request'),
            ),
          ],
        ),
      ),
    );
  }
}
