class UserMember {
  int userId;
  int memberId;

  UserMember({
    required this.userId,
    required this.memberId,
  });

  factory UserMember.fromJson(Map<String, dynamic> json) {
    return UserMember(
      userId: json['user_id'],
      memberId: json['member_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['member_id'] = this.memberId;
    return data;
  }

  @override
  String toString() {
    return 'UserMember{userId: $userId, memberId: $memberId}';
  }
}
