import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/common_input.dart';

class FAQS extends StatefulWidget {
  final List<TextEditingController> faqs;
  final List<TextEditingController> faqAns;
  const FAQS({Key key, this.faqs, this.faqAns}) : super(key: key);
  @override
  _FAQSState createState() => _FAQSState();
}

class _FAQSState extends State<FAQS> {
  bool _isOpen = false;

  void _updateFaq(String faq, String ans) {
    final _controllerFaq = TextEditingController();
    final _controllerFaqAns = TextEditingController();
    _controllerFaq.text = faq;
    _controllerFaqAns.text = ans;
    widget.faqs.add(_controllerFaq);
    widget.faqAns.add(_controllerFaqAns);
    setState(() {});
  }

  void _removeFaq(int index) {
    widget.faqs.removeAt(index);
    widget.faqAns.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: [
                Text(
                  'FAQs'.tr(),
                  style: theme.textTheme.headline6
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                _isOpen
                    ? const Icon(Icons.arrow_drop_down)
                    : const SizedBox(
                        width: 23,
                        height: 23,
                        child: Icon(Icons.arrow_right),
                      )
              ],
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        if (_isOpen)
          ...List.generate(
            widget.faqs.length,
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: theme.accentColor,
                            ),
                          ),
                          child: Text(
                            'FAQ ${index + 1}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        flex: 4,
                        child: CommonInput(
                          controller: widget.faqs[index],
                          hintText: 'questionFAQ'.plural(index + 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: theme.accentColor,
                            ),
                          ),
                          child: Text(
                            'ANS ${index + 1}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        flex: 4,
                        child: CommonInput(
                          controller: widget.faqAns[index],
                          hintText: 'answerFAQ'.plural(index + 1),
                          multiLine: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: InkWell(
                      onTap: () => _removeFaq(index),
                      child: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.only(top: 10.0),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        if (_isOpen) ...[
          Center(
            child: InkWell(
              onTap: () => _updateFaq('', ''),
              child: const Icon(
                Icons.add,
                color: Colors.green,
              ),
            ),
          )
        ],
        const SizedBox(height: 10.0),
      ],
    );
  }
}
