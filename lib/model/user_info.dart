class UserInformation {
  String user_id;
  String user_name;
  String user_icon;
  String user_birth;
  int user_sex;
  String user_signal;
  String user_address;
  String user_password;
  String user_token;
  String user_status;
  String user_register_time;
  String user_register_ip;
  String user_lastlogin_time;
  String user_phone;
  String user_role;
  String user_balance;
  String user_art_coin;

  UserInformation({
    this.user_id,
    this.user_name,
    this.user_icon,
    this.user_birth,
    this.user_sex,
    this.user_signal,
    this.user_address,
    this.user_password,
    this.user_token,
    this.user_status,
    this.user_register_time,
    this.user_register_ip,
    this.user_lastlogin_time,
    this.user_phone,
    this.user_role,
    this.user_balance,
    this.user_art_coin,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
        user_id: json['user_id'],
        user_name: json['user_name'],
        user_icon: json['user_icon'],
        user_birth: json['user_birth'],
        user_sex: json['user_sex'],
        user_password: json['user_password'],
        user_token: json['user_token'],
        user_status: json['user_status'],
        user_register_time: json['user_register_time'],
        user_register_ip: json['user_register_ip'],
        user_lastlogin_time: json['user_lastlogin_time'],
        user_phone: json['user_phone'],
        user_role: json['user_role'],
        user_balance: json['user_balance'],
        user_art_coin: json['user_art_coin']);
  }
}
