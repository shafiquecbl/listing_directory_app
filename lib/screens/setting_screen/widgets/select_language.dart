import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/search_input.dart';
import '../../../configs/app_config.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final TextEditingController _controller = TextEditingController();
  var languages = [];
  var currentLocale;
  @override
  void initState() {
    AppConfig.supportedLocales.forEach((element) {
      languages.add(element);
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currentLocale = context.locale;
      setState(() {});
    });
  }

  void _onSearch(String term) {
    languages.clear();
    AppConfig.supportedLocales.forEach((locale) {
      if (locale.keys.first.tr().toLowerCase().contains(term.toLowerCase())) {
        languages.add(locale);
      }
    });
    setState(() {});
  }

  void _onClear() {
    languages.clear();
    _controller.clear();
    AppConfig.supportedLocales.forEach((element) {
      languages.add(element);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          children: [
            SearchInput(
              controller: _controller,
              height: 40.0,
              onChanged: _onSearch,
              onClear: _onClear,
              onSubmitted: (val) => null,
              enabledInput: true,
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    currentLocale =
                        languages[index][languages[index].keys.first]['locale'];
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CachedNetworkImage(
                          imageUrl: languages[index]
                              [languages[index].keys.first]['icon'],
                          width: 25.0,
                          height: 25.0,
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          languages[index].keys.first,
                          style: Theme.of(context).textTheme.headline6,
                        ).tr(),
                        if (languages[index][languages[index].keys.first]
                                ['locale'] ==
                            currentLocale) ...[
                          const SizedBox(width: 10.0),
                          const Icon(Icons.check),
                        ]
                      ],
                    ),
                  ),
                ),
                itemCount: languages.length,
                cacheExtent: 1000,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.locale = currentLocale;
              },
              child: const Text('apply').tr(),
            )
          ],
        ));
  }
}
