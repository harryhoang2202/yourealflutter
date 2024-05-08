import 'package:youreal/services/domain/auth/models/user.dart';

class RoleRequiring {
  int? id;
  int? roleId;
  String? role;
  String? requesterNote;
  String? adminNote;
  String? requesterId;
  User? requester;
  String? createdTime;
  String? updatedTime;
  int? statusId;
  String? status;
  String? portrait;
  String? idCard;
  String? financialCapacity;

  RoleRequiring(
      {this.id,
      this.roleId,
      this.role,
      this.requesterNote,
      this.adminNote,
      this.requesterId,
      this.requester,
      this.createdTime,
      this.updatedTime,
      this.statusId,
      this.status,
      this.portrait,
      this.idCard,
      this.financialCapacity});

  RoleRequiring.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['roleId'];
    role = json['role'];
    requesterNote = json['requesterNote'];
    adminNote = json['adminNote'];
    requesterId = json['requesterId'];
    requester =
        json['requester'] != null ? User.fromJson(json['requester']) : null;
    createdTime = json['createdTime'];
    updatedTime = json['updatedTime'];
    statusId = json['statusId'];
    status = json['status'];
    portrait = json['portrait'];
    idCard = json['idCard'];
    financialCapacity = json['financialCapacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['roleId'] = roleId;
    data['role'] = role;
    data['requesterNote'] = requesterNote;
    data['adminNote'] = adminNote;
    data['requesterId'] = requesterId;
    if (requester != null) {
      data['requester'] = requester!.toJson();
    }
    data['createdTime'] = createdTime;
    data['updatedTime'] = updatedTime;
    data['statusId'] = statusId;
    data['status'] = status;
    data['portrait'] = portrait;
    data['idCard'] = idCard;
    data['financialCapacity'] = financialCapacity;
    return data;
  }
}
