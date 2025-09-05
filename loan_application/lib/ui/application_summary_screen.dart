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
    this.age = 20,
    this.loanAmount = 45000,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final double approvalLoanAmount = args != null && args['loanAmount'] != null
        ? args['loanAmount'] as double
        : loanAmount;
    final int displayAge = args != null && args['age'] != null
        ? args['age'] as int
        : age;
    final bool isApproved = result.toLowerCase().contains('approved');
    return Scaffold(
      appBar: AppBar(title: Text('Application Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: isApproved ? Colors.green[50] : Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isApproved ? Icons.check_circle : Icons.cancel,
                    color: isApproved ? Colors.green : Colors.red,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    isApproved ? 'Loan Approved!' : 'Loan Not Approved',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isApproved ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 24),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.deepPurple),
                    title: Text('Name'),
                    subtitle: Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.cake, color: Colors.deepPurple),
                    title: Text('Age'),
                    subtitle: Text('$displayAge'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.currency_rupee,
                      color: Colors.deepPurple,
                    ),
                    title: Text('Loan Amount'),
                    subtitle: Text('₹$approvalLoanAmount'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Result:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    result,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isApproved ? Colors.green : Colors.red,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text(
                      'Confirm',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            isApproved ? 'Loan Approved' : 'Loan Not Approved',
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status: ${isApproved ? 'Approved' : 'Not Approved'}',
                              ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
