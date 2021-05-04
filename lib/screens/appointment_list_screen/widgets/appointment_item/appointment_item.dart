import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../entities/user_appointment.dart';
import '../../../../models/authentication_model.dart';
import 'appointment_item_model.dart';

class AppointmentItem extends StatefulWidget {
  final UserAppointment userAppointment;

  const AppointmentItem({Key key, this.userAppointment}) : super(key: key);

  @override
  _AppointmentItemState createState() => _AppointmentItemState();
}

class _AppointmentItemState extends State<AppointmentItem> {
  void _statusOptionSheet(String value, Function updateValue) {
    var statuses = <String>['PENDING', 'APPROVED', 'CANCELED'];
    var initialIndex = statuses.indexWhere((element) => element == value);
    var status = value;
    showModalBottomSheet(
      context: (context),
      builder: (subContext) => Container(
        height: 250,
        child: CupertinoPicker(
          itemExtent: 50.0,
          scrollController:
              FixedExtentScrollController(initialItem: initialIndex),
          onSelectedItemChanged: (index) {
            status = statuses[index];
          },
          children: List.generate(
            statuses.length,
            (index) => Center(
              child: Text(
                statuses[index].tr(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() => updateValue(status));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    return ChangeNotifierProvider<AppointmentItemModel>(
      create: (_) => AppointmentItemModel(widget.userAppointment),
      child: Consumer<AppointmentItemModel>(
        builder: (_, model, __) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
          height: model.isOpen ? 220.0 : 115.0,
          margin: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.userAppointment.featuredImage,
                      fit: BoxFit.cover,
                      width: 60.0,
                      height: 60.0,
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userAppointment.title,
                          style: theme.textTheme.subtitle1
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.userAppointment.cbDay} ${widget.userAppointment.cbDate}',
                          style: theme.textTheme.caption,
                        ),
                        Text(
                            '${widget.userAppointment.cbStartTime} - ${widget.userAppointment.cbEndTime}',
                            style: theme.textTheme.caption),
                      ],
                    ),
                    const Expanded(
                        child: SizedBox(
                      width: 1,
                    )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('status'.tr()),
                        const SizedBox(height: 10.0),
                        InkWell(
                          onTap: () {
                            _statusOptionSheet(
                                model.userAppointment.lpBookingStatus,
                                (val) => model.updateStatus(user, val));
                          },
                          child: Container(
                            height: 25.0,
                            width: 100.0,
                            padding: const EdgeInsets.only(left: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: widget.userAppointment.lpBookingStatus ==
                                      'PENDING'
                                  ? Colors.orange
                                  : widget.userAppointment.lpBookingStatus ==
                                          'CANCELED'
                                      ? Colors.red
                                      : Colors.green,
                            ),
                            child: model.state == AppointmentItemState.loaded
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(widget
                                              .userAppointment.lpBookingStatus)
                                          .tr(),
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  )
                                : const Center(
                                    child: SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              InkWell(
                onTap: model.updateIsOpen,
                child: Container(
                  padding: const EdgeInsets.only(left: 5.0, right: 2.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'details'.tr(),
                        style: theme.textTheme.subtitle2,
                      ),
                      Icon(model.isOpen
                          ? Icons.arrow_drop_down
                          : Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                height: model.isOpen ? 105 : 0,
                child: Column(
                  children: [
                    Flexible(
                      child: Container(
                        height: 25.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            if (model.isOpen)
                              const Icon(
                                FontAwesomeIcons.home,
                                size: 16.0,
                              ),
                            if (!model.isOpen)
                              Container(
                                width: 16.0,
                              ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                widget.userAppointment.gAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        height: 25.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            if (model.isOpen)
                              const Icon(
                                FontAwesomeIcons.user,
                                size: 16.0,
                              ),
                            if (!model.isOpen)
                              Container(
                                width: 16.0,
                              ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                  '${widget.userAppointment.cbName} ${widget.userAppointment.cbLName}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        height: 25.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            if (model.isOpen)
                              const Icon(
                                FontAwesomeIcons.inbox,
                                size: 16.0,
                              ),
                            if (!model.isOpen)
                              Container(
                                width: 16.0,
                              ),
                            const SizedBox(width: 8.0),
                            Flexible(child: Text(widget.userAppointment.cbMsg)),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        height: 25.0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            if (model.isOpen)
                              const Icon(
                                FontAwesomeIcons.envelope,
                                size: 16.0,
                              ),
                            if (!model.isOpen)
                              Container(
                                width: 16.0,
                              ),
                            const SizedBox(width: 8.0),
                            Flexible(
                                child: Text(widget.userAppointment.cbEmail)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
