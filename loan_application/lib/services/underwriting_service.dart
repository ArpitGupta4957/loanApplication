// Service for AI Underwriting

class UnderwritingService {
  Future<String> evaluateApplication({
    required String name,
    required int age,
    required double loanAmount,
  }) async {
    // Simulate AI underwriting logic
    await Future.delayed(Duration(seconds: 2));
    if (age < 18) {
      return 'Application Rejected: Age must be 18+';
    }
    if (loanAmount > 100000) {
      return 'Application Rejected: Amount exceeds limit';
    }
    return 'Application Approved for $name';
  }
}
