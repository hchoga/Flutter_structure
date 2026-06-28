class User {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final bool isEmailVerified;
  final String accessToken;
  final String? employeeCode;
  final List<String>? roles;
  final Map<String, dynamic>? branch;
  final String? day;
  final String? time;
  final bool accessDashboard;
  final bool isManager;
  final bool isAdmin;
  final bool isOpenBalance;
  final String? openedBalanceId;
  final double cashTotal;
  final double visaTotal;
  final double balanceTotal;
  final List<String>? permissions;
  final Map<String, dynamic>? systemModules;
  final List<dynamic>? facility;
  final List<dynamic>? financialPeriod;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.isEmailVerified,
    required this.accessToken,
    this.employeeCode,
    this.roles,
    this.branch,
    this.day,
    this.time,
    this.accessDashboard = false,
    this.isManager = false,
    this.isAdmin = false,
    this.isOpenBalance = false,
    this.openedBalanceId,
    this.cashTotal = 0.0,
    this.visaTotal = 0.0,
    this.balanceTotal = 0.0,
    this.permissions,
    this.systemModules,
    this.facility,
    this.financialPeriod,
  });
}
