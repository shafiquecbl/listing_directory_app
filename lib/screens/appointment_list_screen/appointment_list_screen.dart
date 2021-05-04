import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../models/authentication_model.dart';
import 'appointment_list_screen_model.dart';
import 'widgets/appointment_item/appointment_item.dart';

class AppointmentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<AppointmentListScreenModel>(
      create: (_) => AppointmentListScreenModel(user),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          brightness: theme.brightness,
          backgroundColor: theme.backgroundColor,
          title: Text(
            'appointments'.tr(),
            style: theme.textTheme.headline6,
          ),
          centerTitle: true,
        ),
        body: Container(
          width: size.width,
          height: size.height,
          child: Consumer<AppointmentListScreenModel>(
            builder: (_, model, __) => SmartRefresher(
              enablePullUp: true,
              onLoading: model.loadAppointments,
              onRefresh: model.getAppointments,
              controller: model.refreshController,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (model.state == AppointmentListState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (model.appointments.isEmpty) {
                    return Center(
                      child: Text(
                        'noData'.tr(),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) => AppointmentItem(
                      userAppointment: model.appointments[index],
                    ),
                    itemCount: model.appointments.length,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
