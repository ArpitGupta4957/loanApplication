import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/underwriting_service.dart';
import 'approval_screen.dart';

class UnderwritingScreen extends StatefulWidget {
  const UnderwritingScreen({super.key});

  @override
  State<UnderwritingScreen> createState() => _UnderwritingScreenState();
}

class _UnderwritingScreenState extends State<UnderwritingScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String age = '';
  String loanAmount = '';
  XFile? statementFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickStatement() async {
    final XFile? file = await _picker.pickImage(
      source:
          await showDialog<ImageSource>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Select Source'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                  child: Text('Take a Picture'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                  child: Text('Choose from Device'),
                ),
              ],
            ),
          ) ??
          ImageSource.gallery,
    );
    if (file != null) {
      setState(() {
        statementFile = file;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Statement/Pay Slip uploaded: ${file.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CIBIL score and other verifications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => setState(() => name = value),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => age = value),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your age' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Loan Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => loanAmount = value),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter loan amount' : null,
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.upload_file),
                title: Text('Upload Account Statement or Pay Slip'),
                trailing: ElevatedButton(
                  onPressed: _pickStatement,
                  child: Text('Upload'),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        statementFile != null) {
                      final result = await UnderwritingService()
                          .evaluateApplication(
                            name: name,
                            age: int.tryParse(age) ?? 0,
                            loanAmount: double.tryParse(loanAmount) ?? 0.0,
                          );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApprovalScreen(
                            isApproved: result.contains('Approved'),
                            bankAccount: 'XXXX-1234',
                            loanDetails: result,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please upload your account statement or pay slip.',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
