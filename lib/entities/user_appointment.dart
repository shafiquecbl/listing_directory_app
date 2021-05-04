import '../configs/app_constants.dart';
import '../tools/tools.dart';

class UserAppointment {
  int bookingId;
  String title;
  String featuredImage;
  String listingId;
  String bookerId;
  String avatar;
  String gAddress;
  String lpBookingStatus;
  String cbDate;
  String cbDay;
  String cbStartTime;
  String cbEndTime;
  String cbEmail;
  String cbPhone;
  String cbMsg;
  String cbName;
  String cbLName;

  UserAppointment(
      {this.bookingId,
      this.title,
      this.featuredImage,
      this.listingId,
      this.bookerId,
      this.avatar,
      this.gAddress,
      this.lpBookingStatus,
      this.cbDate,
      this.cbDay,
      this.cbStartTime,
      this.cbEndTime,
      this.cbEmail,
      this.cbPhone,
      this.cbMsg,
      this.cbName,
      this.cbLName});

  UserAppointment.fromJson(Map<String, dynamic> json) {
    try {
      bookingId = json['booking_id'];
      title = json['listing_title'];
      featuredImage = json['featured_image'] ?? kDefaultImage;
      listingId = json['listing_id'];
      bookerId = json['booker_id'];
      avatar = json['avatar'];
      gAddress = json['gAddress'];
      lpBookingStatus = json['lp_booking_status'];
      cbDate = json['cb_date'];
      cbDay = json['cb_day'];
      cbStartTime = json['cb_start_time'];
      cbEndTime = json['cb_end_time'];
      cbEmail = json['cb_email'];
      cbPhone = json['cb_phone'];
      cbMsg = json['cb_msg'];
      cbName = json['cb_name'];
      cbLName = json['cb_lName'];
    } catch (e) {
      log(e);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['listing_title'] = title;
    data['featured_image'] = featuredImage;
    data['listing_id'] = listingId;
    data['booker_id'] = bookerId;
    data['avatar'] = avatar;
    data['gAddress'] = gAddress;
    data['lp_booking_status'] = lpBookingStatus;
    data['cb_date'] = cbDate;
    data['cb_day'] = cbDay;
    data['cb_start_time'] = cbStartTime;
    data['cb_end_time'] = cbEndTime;
    data['cb_email'] = cbEmail;
    data['cb_phone'] = cbPhone;
    data['cb_msg'] = cbMsg;
    data['cb_name'] = cbName;
    data['cb_lName'] = cbLName;
    return data;
  }
}
