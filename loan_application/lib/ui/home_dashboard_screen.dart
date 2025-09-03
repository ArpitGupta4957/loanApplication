import 'package:flutter/material.dart';
import 'package:loan_application/ui/loan_application_screen.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';

class HomeDashboardScreen extends StatelessWidget {
  final String userName;
  const HomeDashboardScreen({super.key, this.userName = 'User'});

  String getUserGreeting(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case 'hi':
        return 'नमस्ते, $userName! 👋';
      case 'en':
      default:
        return 'Hello, $userName! 👋';
    }
  }

  String getSubtitle(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case 'hi':
        return 'आपका विश्वसनीय लोन साथी';
      case 'en':
      default:
        return 'Your trusted loan partner';
    }
  }

  String getMicInstruction(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    switch (locale.languageCode) {
      case 'hi':
        return 'बटन दबाएं और बोलें\n"मुझे लोन चाहिए"';
      case 'en':
      default:
        return 'Press the button and say\n"I want a loan"';
    }
  }

  String getLoanLabel(BuildContext context, String type) {
    Locale locale = Localizations.localeOf(context);
    switch (type) {
      case 'instant':
        return locale.languageCode == 'hi' ? 'तुरंत' : 'Instant';
      case 'popular':
        return locale.languageCode == 'hi' ? 'लोकप्रिय' : 'Popular';
      case 'maximum':
        return locale.languageCode == 'hi' ? 'अधिकतम' : 'Maximum';
      default:
        return type;
    }
  }

  String getEMITitle(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    return locale.languageCode == 'hi' ? 'EMI कैलकुलेटर' : 'EMI Calculator';
  }

  String getEMISubtitle(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    return locale.languageCode == 'hi'
        ? 'अपनी मासिक किस्त जानें'
        : 'Check your monthly EMI';
  }

  String getLoansTitle(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    return locale.languageCode == 'hi' ? 'मेरे लोन' : 'My Loans';
  }

  String getLoansSubtitle(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    return locale.languageCode == 'hi' ? 'सभी लोन देखें' : 'View all loans';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A5AE0), Color(0xFF8F67E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              children: [
                Text(
                  getUserGreeting(context),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  getSubtitle(context),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFF7B2D9), Color(0xFFF7B2D9)],
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.mic, size: 48, color: Color(0xFF6A5AE0)),
                ),
                SizedBox(height: 12),
                Text(
                  getMicInstruction(context),
                  style: TextStyle(color: Color(0xFF6A5AE0), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LoanAmountCard(
                amount: '₹5,000',
                label: getLoanLabel(context, 'instant'),
              ),
              _LoanAmountCard(
                amount: '₹10,000',
                label: getLoanLabel(context, 'popular'),
                isPopular: true,
              ),
              _LoanAmountCard(
                amount: '₹25,000',
                label: getLoanLabel(context, 'maximum'),
              ),
            ],
          ),
          SizedBox(height: 24),
          _DashboardTile(
            icon: Icons.bar_chart,
            title: getEMITitle(context),
            subtitle: getEMISubtitle(context),
            onTap: () {},
          ),
          SizedBox(height: 12),
          _DashboardTile(
            icon: Icons.list_alt,
            title: getLoansTitle(context),
            subtitle: getLoansSubtitle(context),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _LoanAmountCard extends StatelessWidget {
  final String amount;
  final String label;
  final bool isPopular;
  const _LoanAmountCard({
    required this.amount,
    required this.label,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoanApplicationScreen()),
        );
      },
      child: Container(
        width: 90,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPopular ? Color(0xFF6A5AE0) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isPopular ? Color(0xFF6A5AE0) : Colors.grey.shade300,
            width: isPopular ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              amount,
              style: TextStyle(
                color: isPopular ? Colors.white : Color(0xFF6A5AE0),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isPopular ? Colors.white : Color(0xFF6A5AE0),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _DashboardTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Color(0xFF6A5AE0).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(icon, color: Color(0xFF6A5AE0)),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }
}
