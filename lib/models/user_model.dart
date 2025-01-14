class UserModel {
  final String id;
  final String email;
  final String currentPlan;
  final String currentDate;
  final int currentScanned;

  UserModel({
    required this.id,
    required this.email,
    required this.currentPlan,
    required this.currentDate,
    required this.currentScanned,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      currentPlan: json['current_plan'],
      currentDate: json['current_date'],
      currentScanned: json['current_scanned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'current_plan': currentPlan,
      'current_date': currentDate,
      'current_scanned': currentScanned,
    };
  }
}
