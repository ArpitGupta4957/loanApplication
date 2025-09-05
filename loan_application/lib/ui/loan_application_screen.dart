import 'package:flutter/material.dart';
import 'kyc_verification_screen.dart';

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _amount;
  String? _tenure;
  String? _purpose;
  String? _loanType;
  bool _isVerifying = false;

  Widget _buildLoanTypeChip(String label, IconData icon) {
    final selected = _loanType == label;
    return ChoiceChip(
      avatar: CircleAvatar(
        backgroundColor: selected ? Colors.deepPurple : Colors.grey[300],
        child: Icon(icon, color: selected ? Colors.white : Colors.deepPurple),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.deepPurple,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: selected,
      selectedColor: Colors.deepPurple,
      backgroundColor: Colors.deepPurple[50],
      elevation: 2,
      onSelected: (val) {
        setState(() => _loanType = label);
      },
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _submitLoanRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_loanType == null) {
        setState(() {});
        return;
      }
      setState(() {
        _isVerifying = true;
      });
      await Future.delayed(Duration(seconds: 20));
      setState(() {
        _isVerifying = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KYCVerificationScreen(isVerified: true),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply for Loan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Loan Application',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildLoanTypeChip('Personal', Icons.person),
                    _buildLoanTypeChip('Business', Icons.business_center),
                    _buildLoanTypeChip('Education', Icons.school),
                  ],
                ),
                SizedBox(height: 18),
                if (_loanType == null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Please select a loan type',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.currency_rupee,
                      color: Colors.deepPurple,
                    ),
                    labelText: 'Amount (₹) *',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => setState(() => _amount = v),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Amount is required';
                    }
                    if (double.tryParse(v.trim()) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.deepPurple,
                    ),
                    labelText: 'Tenure (months) *',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => setState(() => _tenure = v),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Tenure is required';
                    }
                    if (int.tryParse(v.trim()) == null) {
                      return 'Enter a valid number of months';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.edit, color: Colors.deepPurple),
                    labelText: 'Purpose *',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onChanged: (v) => setState(() => _purpose = v),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Purpose is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                _isVerifying
                    ? Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text(
                              'Verifying...',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
                        icon: Icon(Icons.send, color: Colors.white),
                        label: Text(
                          'Submit Loan Request',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: _submitLoanRequest,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
