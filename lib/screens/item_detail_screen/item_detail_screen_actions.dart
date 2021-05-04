part of 'item_detail_screen.dart';

extension ItemDetailScreenActions on _ItemDetailScreenState {
  String _buildUrl() {
    var defaultLocation = <String, String>{
      'latitude': '${widget.listing.lpListingproOptions.latitude}',
      'longitude': '${widget.listing.lpListingproOptions.longitude}'
    };

    var googleMapsApiKey;
    if (!AppConfig.webPlatform) {
      googleMapsApiKey = Platform.isAndroid
          ? AppConfig.googleAndroidMapApi
          : AppConfig.googleIOSMapApi;
    } else {
      googleMapsApiKey = AppConfig.googleAndroidMapApi;
    }

    var mapURL = Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        port: 443,
        path: '/maps/api/staticmap',
        queryParameters: {
          'size': '800x600',
          'center':
              '${defaultLocation['latitude']},${defaultLocation['longitude']}',
          'zoom': '16',
          'maptype': 'roadmap',
          'markers':
              'color:red|label:C|${widget.listing.lpListingproOptions.latitude},${widget.listing.lpListingproOptions.longitude}',
          'key': '$googleMapsApiKey'
        });
    return mapURL.toString();
  }

  Widget _buildListTag() {
    final theme = Theme.of(context);
    var widgets = <Widget>[];
    if (widget.listing.pureTaxonomies.tags != null) {
      widgets.add(Wrap(
        children: List.generate(
            widget.listing.pureTaxonomies.tags.length,
            (index) => Container(
                margin: const EdgeInsets.only(right: 5.0, top: 10.0),
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: theme.accentColor, width: 1),
                ),
                child: Text(
                  widget.listing.pureTaxonomies.tags[index].name,
                  style: theme.textTheme.caption,
                ))),
      ));
    }

    if (widgets.isNotEmpty) {
      widgets.insert(
          0,
          Text(
            'tags'.tr(),
            style: theme.textTheme.headline6,
          ));
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      );
    }
    return Container();
  }

  Widget _buildLocation() {
    final theme = Theme.of(context);
    var widgets = <Widget>[];
    if (widget.listing.pureTaxonomies.location != null) {
      widgets.add(Wrap(
        children: List.generate(
            widget.listing.pureTaxonomies.location.length,
            (index) => Container(
                margin: const EdgeInsets.only(right: 5.0, top: 10.0),
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: theme.accentColor, width: 1),
                ),
                child: Text(
                  widget.listing.pureTaxonomies.location[index].name,
                  style: theme.textTheme.caption,
                ))),
      ));
    }

    if (widgets.isNotEmpty) {
      widgets.insert(
          0,
          Text(
            'location'.tr(),
            style: theme.textTheme.headline6,
          ));
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      );
    }
    return Container();
  }

  Widget _buildFeature() {
    final theme = Theme.of(context);
    var widgets = <Widget>[];
    if (widget.listing.pureTaxonomies.features != null) {
      widgets.add(Wrap(
        children: List.generate(
            widget.listing.pureTaxonomies.features.length,
            (index) => Container(
                margin: const EdgeInsets.only(right: 5.0, top: 10.0),
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: theme.accentColor, width: 1),
                ),
                child: Text(
                  widget.listing.pureTaxonomies.features[index].name,
                  style: theme.textTheme.caption,
                ))),
      ));
    }

    if (widgets.isNotEmpty) {
      widgets.insert(
          0,
          Text(
            'features'.tr(),
            style: theme.textTheme.headline6,
          ));
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      );
    }
    return Container();
  }

  Widget _buildContact() {
    final theme = Theme.of(context);
    var widgets = <Widget>[];
    if (!Tools.checkEmptyString(widget.listing.lpListingproOptions.website)) {
      widgets.add(SocialContact(
          icon: FontAwesomeIcons.globe,
          value: widget.listing.lpListingproOptions.website,
          type: SocialType.url));
    }
    if (!Tools.checkEmptyString(widget.listing.lpListingproOptions.phone)) {
      widgets.add(SocialContact(
          icon: FontAwesomeIcons.mobile,
          value: widget.listing.lpListingproOptions.phone,
          type: SocialType.phone));
    }
    if (!Tools.checkEmptyString(widget.listing.lpListingproOptions.email)) {
      widgets.add(SocialContact(
          icon: FontAwesomeIcons.voicemail,
          value: widget.listing.lpListingproOptions.email,
          type: SocialType.email));
    }
    if (!Tools.checkEmptyString(widget.listing.lpListingproOptions.youtube)) {
      widgets.add(SocialContact(
          icon: FontAwesomeIcons.youtube,
          value: widget.listing.lpListingproOptions.youtube,
          type: SocialType.youtube));
    }
    if (!Tools.checkEmptyString(widget.listing.lpListingproOptions.twitter)) {
      widgets.add(SocialContact(
          icon: FontAwesomeIcons.twitter,
          value: widget.listing.lpListingproOptions.twitter,
          type: SocialType.twitter));
    }
    if (!Tools.checkEmptyString(widget.listing.lpListingproOptions.facebook)) {
      widgets.add(SocialContact(
          icon: FontAwesomeIcons.facebook,
          value: widget.listing.lpListingproOptions.facebook,
          type: SocialType.facebook));
    }
    if (!Tools.checkEmptyString(widget.listing.lpListingproOptions.linkedin)) {
      widgets.add(SocialContact(
        icon: FontAwesomeIcons.linkedin,
        value: widget.listing.lpListingproOptions.linkedin,
        type: SocialType.linkedIn,
      ));
    }
    if (!Tools.checkEmptyString(widget.listing.lpListingproOptions.instagram)) {
      widgets.add(SocialContact(
        icon: FontAwesomeIcons.instagram,
        value: widget.listing.lpListingproOptions.instagram,
        type: SocialType.instagram,
      ));
    }
    if (!Tools.checkEmptyString(widget.listing.lpListingproOptions.whatsapp)) {
      widgets.add(SocialContact(
        icon: FontAwesomeIcons.whatsapp,
        value: widget.listing.lpListingproOptions.whatsapp,
        type: SocialType.whatsApp,
      ));
    }
    if (widgets.isNotEmpty) {
      widgets.insert(
          0,
          Text(
            'contact'.tr(),
            style: theme.textTheme.headline6,
          ));
      widgets.insert(
        1,
        const SizedBox(height: 10.0),
      );
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      );
    }

    return Container();
  }

  Widget _buildEventCard() {
    if (widget.listing.events == null || widget.listing.events.isEmpty) {
      return Container();
    }

    var widgets = <Widget>[];

    widgets.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: HeaderWidget(
          title: 'upComingEvents'.tr(),
        ),
      ),
    );
    widgets.add(
      const SizedBox(height: 10.0),
    );
    if (widget.listing.events.length > 1) {
      widgets.add(EventSlider(
        events: widget.listing.events,
      ));
    } else {
      widgets.add(EventItemV1(event: widget.listing.events.first));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  void showOptions(Review review, User user, Function(User, int) onDeleteReview,
      Function(Review) onEditReview) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            'cancel'.tr(),
            style: Theme.of(context).textTheme.headline6,
          ),
          onPressed: () => Navigator.of(context).pop(),
          isDefaultAction: true,
        ),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              'editReview'.tr(),
              style: Theme.of(context).textTheme.headline6,
            ),
            onPressed: () {
              Navigator.pop(context);
              onEditReview(review);
            },
            isDefaultAction: false,
          ),
          CupertinoActionSheetAction(
            child: Text(
              'deleteReview'.tr(),
              style: Theme.of(context).textTheme.headline6,
            ),
            onPressed: () async {
              onDeleteReview(user, review.id);
              Navigator.pop(context);
            },
            isDefaultAction: false,
          ),
        ],
      ),
    );
  }

  void showReviewOption(Review review, User user,
      Function(User, int) onDeleteReview, Function(Review) onEditReview) {
    if (user == null) {
      return;
    }

    if (user.id == review.author) {
      showOptions(review, user, onDeleteReview, onEditReview);
    }
  }

  void _showReviewScreen(ItemDetailScreenModel model, {Review review}) {
    final user = Provider.of<AuthenticationModel>(context, listen: false).user;
    if (user == null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      return;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (subContext) => ChangeNotifierProvider.value(
                value: model,
                child: ReviewSubmit(
                  review: review,
                ))));
  }

  void _showBookingBottomSheet(ItemDetailScreenModel model) {
    final userId =
        Provider.of<AuthenticationModel>(context, listen: false).user?.id;
    if (userId == null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      return;
    }
    if (userId.toString() == widget.listing.authorId) {
      showToast('ownerCannotBook'.tr());
      return;
    }
    showModalBottomSheet(
        context: context,
        builder: (subContext) {
          return BookingWidget(
            listing: widget.listing,
          );
        },
        backgroundColor: Colors.transparent);
  }

  Future<void> _createChat() async {
    final model = Provider.of<AuthenticationModel>(context, listen: false);
    if (model.state == AuthenticationState.notLogin) {
      await Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      return;
    }
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MessageUserScreenV1(
              authorId: widget.listing.authorId,
              authorAvatar: widget.listing.authorAvatar,
              authorName: widget.listing.authorName,
            )));
  }
}
