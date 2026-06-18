class ApiConstants {
  //static const String baseUrl = 'https://hornvin-backend.onrender.com';
  //static const String baseUrl = 'https://hornvin-backend-89cs.onrender.com';
  static const String baseUrl = 'https://hornvin.onrender.com';
  static const String register = '/api/garage/auth/register';
  static const String verifyOtp = '/api/garage/auth/verify-otp';
  static const String login = '/api/garage/auth/login';
  static const String logout = '/api/garage/auth/logout';
  static const String garageLanguage = '/api/garage/auth/language';
  // static const String jobs = '/api/garage/jobs';

  static const String jobs = '/api/job/all';
  static const String createJob = '/api/job-card';
  static const String updateJob = '/api/job/update';
  static const String deleteJob = '/api/job/delete';
  static const String jobHistory = '/api/job/history';
  static const String vehicleHistory = '/api/vehicle-history';
  static const String garageProfile = '/api/garage/auth/profile';
  static const String garageVehicleHistory = '/api/job/garage-history';
  static const String jobCardInspectionChecklist =
      '/api/job-card/inspection-checklist';
  static const String jobCardInspectionResult =
      '/api/job-card/inspection-result';
  static const String twoWheelerInspectionChecklist =
      '/api/job-card/two-wheeler-inspection/checklist';
  static const String twoWheelerInspectionResult =
      '/api/job-card/two-wheeler-inspection/result';

  static const String invoices = '/api/invoice';
  static const String invoiceStats = '/api/invoice/stats';
  static const String createGarageInvoice = '/api/garage/invoices/create';
  static const String garageProducts = '/api/garage/products';
  static const String garageOrders = '/api/garage/orders';
  static const String garageInvoices = '/api/garage/invoices';
  static const String nearestDistributors =
      '/api/location/distributors/nearest';

  // Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
}
