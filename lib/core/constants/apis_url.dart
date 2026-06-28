abstract final class ApisUrl {
  //  https://erp-hr.testdomain100.online/api

  //base url
  static const String baseUrl = "https://erp-hr.testdomain100.online/api";

  // auth apis
  static const String login = "/dashboard-login";

  static const String logout = "/employee_logout";

  static const String resetPassword = "/employees/resetpassword";

  static const String firstLoginPassword = "/create-password-first-login";

  // send otp apis
  static const String sendOtpPassword = "/send-otp-password";

  static const String verifyOtpPassword = "/verify-otp-password";

  //  clock in out apis
  static const String checkInCheckOutAttendance =
      "/hr/attendances/checkin-checkout-attendance";

  // attendance report apis
  static const String getMyAttendances = "/hr/attendances/get-my-attendances";

  // permissions apis

  static const String employeeRequests = "/hr/hr-employee-requests/my-requests";

  static const String hrPermissionRequests = "/hr/hr-permission-requests";

  static const String permissionDeleteApi = "/hr/hr-employee-requests";

  static const String employeeDashBoard = "/hr/hr-employee-requests";

  static const String permissionTypes = "/hr/hr-permissions/list";

  static const String mangerRequests =
      "/hr/hr-employee-requests/employees-requests";

  static const String mangerRequestsApproveOrReject =
      "/hr/hr-employee-requests/approval";

  // work from home apis

  static const String wfhDashBoard = "/hr/hr-employee-requests/wfh-requests";

  static const String wfhRequests = "/hr/hr-wfh-requests";

  // vacation (leave) apis

  static const String leaveDashBoard =
      "/hr/hr-employee-requests/leave-requests";

  static const String hrLeaveRequests = "/hr/hr-leave-requests";

  static const String hrLeaveTypes = "/hr/hr-leave-types/list";

  // overtime apis

  static const String overtimeRequests = "/hr/hr-overtime-requests";

  static const String getOvertimeShift =
      "/hr/hr-overtime-requests/get-overtime";

  // profile apis

  static String employeeShow(int employeeId) => "/employees/show/$employeeId";

  static String employeeUpdateFirst(int employeeId) =>
      "/employees/update/first/$employeeId";

  static String employeeUpdateSecond(int employeeId) =>
      "/employees/update/second/$employeeId";

  static const String maritalStatuses = "/marital_statuses";

  static const String nationalities = "/nationality/index";

  static const String countries = "/country";
}
