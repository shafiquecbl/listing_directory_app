class Appointment {
  String startTime;
  String endTime;
  bool isDayOff = false;
  String epochStart;
  String epochEnd;
  Appointment(this.isDayOff);
  Appointment.fromJson(Map<String, dynamic> json) {
    startTime = json['appt_start'];
    endTime = json['appt_end'];
    epochStart = json['appt_epoch_start'].toString();
    epochEnd = json['appt_epoch_end'].toString();
  }
}
