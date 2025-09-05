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

  Widget _buildDocChip(String label, IconData icon, XFile? file) {
    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: file != null ? Colors.green : Colors.grey[300],
        child: Icon(
          icon,
          color: file != null ? Colors.white : Colors.grey[700],
        ),
      ),
      label: Text(
        file != null ? '$label ✓' : label,
        style: TextStyle(
          color: file != null ? Colors.green : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: file != null ? Colors.green[50] : Colors.grey[100],
      elevation: 2,
      onPressed: () => _pickDocument(label),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildDocChip('Aadhaar Card', Icons.credit_card, aadhaarFile),
                  _buildDocChip('PAN Card', Icons.account_balance, panFile),
                  _buildDocChip(
                    'Bank Account + Passbook',
                    Icons.account_balance_wallet,
                    bankFile,
                  ),
                  _buildDocChip('Profile Picture', Icons.person, profileFile),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'If no internet or issue, you can upload via SMS/WhatsApp Bot.',
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                ),
                icon: Icon(Icons.sms, color: Colors.white),
                label: Text(
                  'Upload via SMS/WhatsApp',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SMSChatbotScreen()),
                  );
                },
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                ),
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                label: Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
