import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/common_input.dart';
import '../../../../common_widgets/skeleton.dart';
import '../../../../entities/appointment.dart';
import '../../../../entities/listing.dart';
import '../../../../models/authentication_model.dart';
import '../../../../services/api_service.dart';
import '../../../../tools/tools.dart';

class BookingWidget extends StatefulWidget {
  final Listing listing;

  const BookingWidget({Key key, this.listing}) : super(key: key);
  @override
  _BookingWidgetState createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  DateTime now = DateTime.now();
  String currentDate;
  String currentDay;
  String currentDayOfWeek;
  int currentIndex = 0;
  final _pageController = PageController();
  int _currentPage = 0;
  final _services = ApiServices();
  List<Appointment> _appointments = [];
  bool isDayOff = false;
  bool isLoading = true;
  bool isBooking = false;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final commentController = TextEditingController();

  @override
  void initState() {
    var df = DateFormat('MMMM, yyyy');
    currentDate = df.format(now);
    df = DateFormat('dd');
    currentDay = df.format(now);
    df = DateFormat('EEEE');
    currentDayOfWeek = df.format(now);
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    emailController.text = user.email;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadAppointments();
    });
  }

  void _updateDate(bool isNext) {
    if (isNext) {
      now = now.add(const Duration(days: 1));
    } else {
      now = now.subtract(const Duration(days: 1));
      if (now.isBefore(DateTime.now())) {
        now = DateTime.now();
      }
    }

    var df = DateFormat('MMMM, yyyy');
    currentDate = df.format(now);
    df = DateFormat('dd');
    currentDay = df.format(now);
    df = DateFormat('EEEE');
    currentDayOfWeek = df.format(now);
    setState(() {});
    _loadAppointments();
  }

  void _loadAppointments() async {
    EasyDebounce.cancel('loadAppointments');
    EasyDebounce.debounce('loadAppointments', const Duration(milliseconds: 500),
        () async {
      isLoading = true;
      setState(() {});
      currentIndex = 0;
      isDayOff = false;
      _appointments.clear();
      var df = DateFormat('yyyy-MM-dd');
      _appointments = await _services.getAppointments(
          fullDate: df.format(now), listingId: widget.listing.id);
      if (_appointments.isNotEmpty && _appointments.first.isDayOff) {
        isDayOff = true;
      }
      isLoading = false;
      setState(() {});
    });
  }

  bool _checkEmptyInfo() {
    if (emailController.text.isEmpty ||
        commentController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneController.text.isEmpty) {
      return true;
    }
    return false;
  }

  void _submitBooking() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_checkEmptyInfo()) {
      showToast('insufficientInfo'.tr());
      return;
    }
    isBooking = true;
    setState(() {});
    final date = '$currentDay $currentDate';
    final timeSlotStrDate = Timestamp.now().millisecondsSinceEpoch;
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    final data = {
      'fName': firstNameController.text,
      'lName': lastNameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'comment': commentController.text,
      'lid': widget.listing.id.toString(),
      'date': date,
      'time':
          '${_appointments[currentIndex].startTime} - ${_appointments[currentIndex].endTime}',
      'timeSlotStr': _appointments[currentIndex].epochStart,
      'timeSlotStrDate': timeSlotStrDate,
      'timeSlotStrEnd': _appointments[currentIndex].epochEnd,
      'id': user.id.toString()
    };

    final isSuccess = await _services.submitBooking(data: data);
    if (isSuccess) {
      Navigator.of(context).pop();
    }
    isBooking = false;
    setState(() {});
    showToast('successfullyBooked'.tr());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: theme.canvasColor,
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10.0),
                          Center(
                            child: Text(
                              currentDate,
                              style: theme.textTheme.headline5,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: Icon(Tools.isDirectionRTL(context)
                                      ? Icons.arrow_forward_ios_sharp
                                      : Icons.arrow_back_ios_sharp),
                                  onPressed: () => _updateDate(false)),
                              const SizedBox(width: 20.0),
                              Text(
                                currentDay,
                                style: theme.textTheme.headline4,
                              ),
                              const SizedBox(width: 20.0),
                              IconButton(
                                  icon: Icon(Tools.isDirectionRTL(context)
                                      ? Icons.arrow_back_ios_sharp
                                      : Icons.arrow_forward_ios_sharp),
                                  onPressed: () => _updateDate(true)),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Center(
                            child: Text(
                              currentDayOfWeek,
                              style: theme.textTheme.headline6,
                            ).tr(),
                          ),
                          const SizedBox(height: 10.0),
                          isDayOff
                              ? Expanded(
                                  child: Center(
                                    child: Text('dayOff'.tr()),
                                  ),
                                )
                              : Flexible(
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () => isLoading
                                          ? null
                                          : setState(
                                              () => currentIndex = index),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 5.0),
                                            decoration: BoxDecoration(
                                                color: currentIndex == index &&
                                                        !isLoading
                                                    ? theme.accentColor
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                isLoading
                                                    ? Skeleton(
                                                        width: 90.0,
                                                        height: 25.0,
                                                      )
                                                    : Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5.0),
                                                        width: 90.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: theme
                                                                      .accentColor,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                        child: Center(
                                                          child: Text(
                                                              _appointments[
                                                                      index]
                                                                  .startTime),
                                                        )),
                                                const SizedBox(width: 5.0),
                                                Container(
                                                  width: 5.0,
                                                  height: 1.0,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 5.0),
                                                isLoading
                                                    ? Skeleton(
                                                        width: 90.0,
                                                        height: 25.0,
                                                      )
                                                    : Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5.0),
                                                        width: 90.0,
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: theme
                                                                      .accentColor,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                        child: Center(
                                                          child: Text(
                                                              _appointments[
                                                                      index]
                                                                  .endTime),
                                                        )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    itemCount:
                                        isLoading ? 10 : _appointments.length,
                                  ),
                                ),
                        ],
                      ),
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'yourInfo'.tr(),
                                style: theme.textTheme.headline4,
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                height: 40.0,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CommonInput(
                                        controller: firstNameController,
                                        hintText: 'firstName'.tr(),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: CommonInput(
                                        controller: lastNameController,
                                        hintText: 'lastName'.tr(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 40.0,
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CommonInput(
                                        controller: phoneController,
                                        hintText: 'phone'.tr(),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: CommonInput(
                                        controller: emailController,
                                        hintText: 'email'.tr(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 40.0,
                                child: CommonInput(
                                  controller: commentController,
                                  hintText: 'yourComment'.tr(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _currentPage == 0 && !isDayOff
                        ? _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn)
                        : _submitBooking(),
                    child: _currentPage == 0
                        ? Text('next'.tr())
                        : Text('bookNow'.tr()),
                  ),
                ),
              ],
            ),
          ),
          if (isBooking)
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}
