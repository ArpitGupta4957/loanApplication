import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home_dashboard_screen.dart';
import 'sms_chatbot_screen.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? aadhaarFile;
  XFile? panFile;
  XFile? bankFile;
  XFile? profileFile;

  Future<void> _pickDocument(String docType) async {
    final XFile? file = await _picker.pickImage(
      source: await _showPickSourceDialog(),
    );
    if (file != null) {
      setState(() {
        switch (docType) {
          case 'Aadhaar Card':
            aadhaarFile = file;
            break;
          case 'PAN Card':
            panFile = file;
            break;
          case 'Bank Account + Passbook':
            bankFile = file;
            break;
          case 'Profile Picture':
            profileFile = file;
            break;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$docType uploaded: ${file.name}')),
      );
    }
  }

  Future<ImageSource> _showPickSourceDialog() async {
    return await showDialog<ImageSource>(
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
        ImageSource.gallery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Documents')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Aadhaar Card'),
                trailing: ElevatedButton(
                  onPressed: () => _pickDocument('Aadhaar Card'),
                  child: Text('Upload'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_balance),
                title: Text('PAN Card'),
                trailing: ElevatedButton(
                  onPressed: () => _pickDocument('PAN Card'),
                  child: Text('Upload'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Bank Account + Passbook'),
                trailing: ElevatedButton(
                  onPressed: () => _pickDocument('Bank Account + Passbook'),
                  child: Text('Upload'),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile Picture'),
                trailing: ElevatedButton(
                  onPressed: () => _pickDocument('Profile Picture'),
                  child: Text('Upload'),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'If no internet or issue, you can upload via SMS/WhatsApp Bot.',
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SMSChatbotScreen()),
                  );
                },
                child: Text('Upload via SMS/WhatsApp'),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    (aadhaarFile != null &&
                        panFile != null &&
                        bankFile != null &&
                        profileFile != null)
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeDashboardScreen(),
                          ),
                        );
                      }
                    : null,
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
