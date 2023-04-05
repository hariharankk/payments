class LeaveRequest {
  final String userid;
  final String leave_key;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String date;

  LeaveRequest({
    required this.userid,
    required this.leave_key,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.date
  });


  String get leave => leave_key!;

  Map<dynamic, dynamic> toMap() {
    var map = new Map<String , dynamic>();
    map['reason'] = reason;
    map['userid'] = userid;
    map['date'] = date;
    map['startDate'] = startDate ;
    map['endDate'] = endDate;
    return map;

  }

  @override
  List<Object> get props => [leave];

  factory LeaveRequest.fromJson(Map<dynamic,dynamic> map) {
    return LeaveRequest(
        userid : map['userid'],
        reason : map['reason'],
        date : map['date'],
        name : map['name'],
        startDate : map['startDate'],
        endDate : map['endDate'],
        leave_key : map['leave_key']
    );
  }


}