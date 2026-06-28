import 'package:touch/features/login/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.phoneNumber,
    required super.isEmailVerified,
    required super.accessToken,
    super.employeeCode,
    super.roles,
    super.branch,
    super.day,
    super.time,
    super.accessDashboard,
    super.isManager,
    super.isAdmin,
    super.isOpenBalance,
    super.openedBalanceId,
    super.cashTotal,
    super.visaTotal,
    super.balanceTotal,
    super.permissions,
    super.systemModules,
    super.facility,
    super.financialPeriod,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Extract from the API response structure: {status, message, code, data: {access_token, employee, ...}}
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final employee = data['employee'] as Map<String, dynamic>? ?? {};
    final branch = data['branch'] as Map<String, dynamic>?;
    final roles = data['role'] as List<dynamic>?;
    final permissions = data['permissions'] as List<dynamic>?;
    final systemModules = data['system_modules'] as Map<String, dynamic>?;
    final facility = data['facility'] as List<dynamic>?;
    final financialPeriod = data['financialPeriod'] as List<dynamic>?;

    final fullName =
        '${employee['first_name'] ?? ''} ${employee['last_name'] ?? ''}'.trim();

    return UserModel(
      id: (employee['id'] ?? 0).toString(),
      email: employee['email'] as String? ?? '',
      name: fullName.isNotEmpty
          ? fullName
          : employee['name'] as String? ?? 'User',
      phoneNumber: employee['phone_number'] as String?,
      isEmailVerified: true,
      accessToken: data['access_token'] as String? ?? '',
      employeeCode: employee['employee_code'] as String?,
      roles: roles?.map((e) => e.toString()).toList(),
      branch: branch,
      day: data['day'] as String?,
      time: data['time'] as String?,
      accessDashboard: data['access_dashboard'] as bool? ?? false,
      isManager: data['is_manager'] as bool? ?? false,
      isAdmin: data['is_admin'] as bool? ?? false,
      isOpenBalance: data['is_open_balance'] as bool? ?? false,
      openedBalanceId: data['opened_balance_id'] as String?,
      cashTotal: (data['cash_total'] as num?)?.toDouble() ?? 0.0,
      visaTotal: (data['visa_total'] as num?)?.toDouble() ?? 0.0,
      balanceTotal: (data['balance_total'] as num?)?.toDouble() ?? 0.0,
      permissions: permissions?.map((e) => e.toString()).toList(),
      systemModules: systemModules,
      facility: facility,
      financialPeriod: financialPeriod,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified,
      'accessToken': accessToken,
      'employeeCode': employeeCode,
      'roles': roles,
      'branch': branch,
      'day': day,
      'time': time,
      'accessDashboard': accessDashboard,
      'isManager': isManager,
      'isAdmin': isAdmin,
      'isOpenBalance': isOpenBalance,
      'openedBalanceId': openedBalanceId,
      'cashTotal': cashTotal,
      'visaTotal': visaTotal,
      'balanceTotal': balanceTotal,
      'permissions': permissions,
      'systemModules': systemModules,
      'facility': facility,
      'financialPeriod': financialPeriod,
    };
  }
}
