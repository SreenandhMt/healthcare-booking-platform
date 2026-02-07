class LoginModel {
  final bool status;
  final String message;
  final String? token;
  final bool? isSuperuser;
  final UserDetailsModel? userDetails;

  LoginModel({
    required this.status,
    required this.message,
    this.token,
    this.isSuperuser,
    this.userDetails,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      isSuperuser: json['is_superuser'],
      userDetails: json['user_details'] != null
          ? UserDetailsModel.fromJson(json['user_details'])
          : null,
    );
  }
}

class UserDetailsModel {
  final int id;
  final String? lastLogin;
  final String name;
  final String phone;
  final String address;
  final String mail;
  final String username;
  final int admin;
  final bool isAdmin;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  UserDetailsModel({
    required this.id,
    this.lastLogin,
    required this.name,
    required this.phone,
    required this.address,
    required this.mail,
    required this.username,
    required this.admin,
    required this.isAdmin,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      id: json['id'],
      lastLogin: json['last_login'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      mail: json['mail'] ?? '',
      username: json['username'] ?? '',
      admin: json['admin'] ?? 0,
      isAdmin: json['is_admin'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_login': lastLogin,
      'name': name,
      'phone': phone,
      'address': address,
      'mail': mail,
      'username': username,
      'admin': admin,
      'is_admin': isAdmin,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
