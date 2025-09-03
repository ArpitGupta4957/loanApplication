import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'application_summary_screen.dart';

class ApprovalScreen extends StatefulWidget {
  final bool isApproved;
  final String bankAccount;
  final String loanDetails;
  const ApprovalScreen({
    super.key,
    this.isApproved = true,
    this.bankAccount = '',
    this.loanDetails = '',
  });

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final TextEditingController _loanAmountController = TextEditingController();

  Future<void> sendNotification(String loanDetails) async {
    final smsUri = Uri.parse(
      'sms:?body=Your loan is approved! Details: $loanDetails',
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
    final whatsappUri = Uri.parse(
      'https://wa.me/?text=Your loan is approved! Details: $loanDetails',
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loan Approval & Disbursement')),
      body: Center(
        child: widget.isApproved
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 64),
                  SizedBox(height: 16),
                  Text('Loan Approved!', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 16),
                  Text('Amount will be disbursed to your bank account:'),
                  Text(
                    widget.bankAccount,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('Loan Details: ${widget.loanDetails}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await sendNotification(widget.loanDetails);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notification sent via SMS & WhatsApp!',
                          ),
                        ),
                      );
                      double enteredAmount =
                          double.tryParse(_loanAmountController.text) ?? 0.0;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplicationSummaryScreen(
                            name: widget.bankAccount,
                            age: 30,
                            loanAmount: enteredAmount,
                            result: widget.loanDetails,
                          ),
                        ),
                      );
                    },
                    child: Text('Send Notification'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text('Loan Not Approved', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 16),
                ],
              ),
      ),
    );
  }
}
