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
      appBar: AppBar(title: Text('CIBIL & Underwriting Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 18),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                    labelText: 'Name *',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onChanged: (value) => setState(() => name = value),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter your name'
                      : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.cake, color: Colors.deepPurple),
                    labelText: 'Age *',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() => age = value),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your age';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Enter a valid age';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.currency_rupee,
                      color: Colors.deepPurple,
                    ),
                    labelText: 'Loan Amount *',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() => loanAmount = value),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter loan amount';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.upload_file, color: Colors.deepPurple),
                  title: Text('Upload Account Statement or Pay Slip *'),
                  subtitle: statementFile != null
                      ? Text(
                          'Uploaded: ${statementFile!.name}',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        )
                      : Text('Required', style: TextStyle(color: Colors.red)),
                  trailing: ElevatedButton.icon(
                    icon: Icon(Icons.cloud_upload, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _pickStatement,
                    label: Text('Upload'),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 26,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                    ),
                    icon: Icon(Icons.send, color: Colors.white),
                    label: Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
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
                              'All fields and document upload are required.',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
