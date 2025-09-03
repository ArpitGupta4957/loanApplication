import 'dart:io';
import 'package:flutter/material.dart';

class ApplicationSummaryScreen extends StatelessWidget {
  final String name;
  final int age;
  final double loanAmount;
  final String result;

  const ApplicationSummaryScreen({
    super.key,
    required this.name,
    required this.age,
    required this.loanAmount,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final double approvalLoanAmount = args != null && args['loanAmount'] != null
        ? args['loanAmount'] as double
        : loanAmount;
    return Scaffold(
      appBar: AppBar(title: Text('Application Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            Text('Age: $age'),
            Text('Loan Amount: ₹$approvalLoanAmount'),
            SizedBox(height: 16),
            Text(
              'Result: $result',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Loan Approved'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: Approved'),
                            SizedBox(height: 8),
                            Text('Bank Account: XXXX-1234'),
                            SizedBox(height: 8),
                            Text(
                              'Loan Details: EMI: ₹2000/month, Tenure: 12 months',
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  exit(0);
                                },
                              );
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
