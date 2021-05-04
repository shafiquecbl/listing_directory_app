import 'package:intl/intl.dart';

class Event {
  String eventTitle;
  String eventDate;
  String eventTime;
  String eventLon;
  String eventLat;
  String eventLoc;
  String eventTicketUrl;
  String eventFeaturedImage;
  Event({
    eventTitle,
    eventDate,
    eventTime,
    eventLon,
    eventLat,
    eventLoc,
    eventTicketUrl,
    eventFeaturedImage,
  });

  Event.fromJson(Map<String, dynamic> json) {
    eventTitle = json['event_title'];
    eventDate = json['event_date'];
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(eventDate) * 1000);
    var formattedDate = DateFormat.yMMMd().format(date);
    eventDate = formattedDate;
    eventTime = json['event_time'];
    eventLon = json['event_lon'];
    eventLat = json['event_lat'];
    eventLoc = json['event_loc'];
    eventTicketUrl = json['event_ticket_url'];
    // eventTicketUrl = eventTicketUrl.split('|')[1];
    eventFeaturedImage = json['event_featured_image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['event_title'] = eventTitle;
    data['event_date'] = eventDate;
    data['event_time'] = eventTime;
    data['event_lon'] = eventLon;
    data['event_lat'] = eventLat;
    data['event_loc'] = eventLoc;
    data['event_ticket_url'] = eventTicketUrl;
    data['event_featured_image'] = eventFeaturedImage;

    return data;
  }
}
