/// Route names as enum with path and name for type-safe navigation
/// Following SOLID principles (Single Responsibility Principle)
enum RoutesName {
  splash(path: '/', name: 'Splash Page'),
  login(path: '/login', name: 'Login Page'),
  forgotPassword(path: '/forgot-password', name: 'Forgot Password Page'),
  createPasswordFirstLogin(
    path: '/create-password-first-login',
    name: 'Create Password First Login Page',
  ),
  otpPage(path: '/otpPage', name: 'Otp Page'),
  home(path: '/home', name: 'Home Page'),
  homeDetail(path: '/home/detail/:id', name: 'Home Detail Page'),
  permissionDashBoardScreen(
    path: '/permissionDashBoardScreen',
    name: 'Permission DashBoard Screen',
  ),
  newPermissionRequestScreen(
    path: '/newPermissionRequestScreen',
    name: 'New Permission Request Screen',
  ),
  permissionsListScreen(
    path: '/permissionsListScreen',
    name: 'Permissions List Screen',
  ),
  permissionsOrderDetails(
    path: '/permissionsOrderDetails',
    name: 'Permissions Order Details',
  ),
  wfhDashBoardScreen(path: '/wfhDashBoardScreen', name: 'WFH DashBoard Screen'),
  newWfhRequestScreen(
    path: '/newWfhRequestScreen',
    name: 'New WFH Request Screen',
  ),
  wfhOrderDetails(path: '/wfhOrderDetails', name: 'WFH Order Details'),
  vacationDashBoardScreen(
    path: '/vacationDashBoardScreen',
    name: 'Vacation DashBoard Screen',
  ),
  newVacationRequestScreen(
    path: '/newVacationRequestScreen',
    name: 'New Vacation Request Screen',
  ),
  vacationOrderDetails(
    path: '/vacationOrderDetails',
    name: 'Vacation Order Details',
  ),
  vacationPolicyDetails(
    path: '/vacationPolicyDetails',
    name: 'Vacation Policy Details',
  ),
  newOvertimeRequestScreen(
    path: '/newOvertimeRequestScreen',
    name: 'New Overtime Request Screen',
  ),
  overtimeOrderDetails(
    path: '/overtimeOrderDetails',
    name: 'Overtime Order Details',
  ),
  profileBasicInfo(path: '/profileBasicInfo', name: 'Profile Basic Info'),
  profileContactInfo(path: '/profileContactInfo', name: 'Profile Contact Info'),
  profileJobInfo(path: '/profileJobInfo', name: 'Profile Job Info'),
  profileAdditionalInfo(
    path: '/profileAdditionalInfo',
    name: 'Profile Additional Info',
  ),
  profileLegalDocuments(
    path: '/profileLegalDocuments',
    name: 'Profile Legal Documents',
  ),
  profileEvaluations(path: '/profileEvaluations', name: 'Profile Evaluations'),
  profileEditBasicInfo(
    path: '/profileEditBasicInfo',
    name: 'Profile Edit Basic Info',
  ),
  profileEditContactInfo(
    path: '/profileEditContactInfo',
    name: 'Profile Edit Contact Info',
  ),
  profileEditAdditionalInfo(
    path: '/profileEditAdditionalInfo',
    name: 'Profile Edit Additional Info',
  ),
  attendanceReport(path: '/attendanceReport', name: 'Attendance Report Page'),
  languageScreen(path: '/languageScreen', name: 'Language Screen'),
  testTypography(path: '/test-typography', name: 'Test Typography Page');

  const RoutesName({required this.path, required this.name});

  final String path;
  final String name;
}
