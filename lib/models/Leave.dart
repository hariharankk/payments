class LeaveRequest {
  final String userid;
  final String leave_key;
  final String name;
  final String startDate;
  final String endDate;
  final String reason;
  final String date;
  final String phonenumber;

  LeaveRequest({
    required this.userid,
    required this.leave_key,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.date,
    required this.phonenumber
  });


  String get leave => leave_key!;

  Map<dynamic, dynamic> toMap() {
    var map = new Map<String , dynamic>();
    map['reason'] = reason;
    map['userid'] = userid;
    map['date'] = date;
    map['startDate'] = startDate ;
    map['endDate'] = endDate;
    map['name'] = name;
    map['phonenumber'] = phonenumber;
    return map;

  }

  @override
  List<Object> get props => [leave];

  factory LeaveRequest.fromJson(Map<dynamic,dynamic> map) {
    return LeaveRequest(
        userid : map['userid'],
        reason : map['reason'],
        date : map['duration'],
        name : map['name'],
        startDate : map['start_date'],
        endDate : map['end_date'],
        leave_key : map['leave_key'],
        phonenumber: map['phonenumber']
    );
  }


}