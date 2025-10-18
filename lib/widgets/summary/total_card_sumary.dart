
import "package:flutter/material.dart";
import "package:rachadinha/models/bill.dart";

import "../../screens/summary_screen.dart";
import "../../utils/app_size.dart";
import "../../utils/textfield/formatter/formatter_utils.dart";

class TotalCard extends StatefulWidget {
  final Bill bill;

  const TotalCard({super.key, 
    required this.bill,
  });

  @override
  State<TotalCard> createState() => TotalCardState();
}

class TotalCardState extends State<TotalCard> {
  late TextEditingController _controller;

  String formatPercentage(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString(); // remove .0
    }
    return value.toString();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: formatPercentage(widget.bill.serviceFeePercentage),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TotalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newPercentage = widget.bill.serviceFeePercentage;
    final formatted = formatPercentage(newPercentage);

    if (_controller.text != formatted) {
      final cursorPos = _controller.selection;
      _controller.text = formatted;
      _controller.selection = cursorPos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.asd),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtotal:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  FormatterUtils.currencyFormat.format(widget.bill.subtotal),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSize.asd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Taxa de Serviço:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Text(
                      FormatterUtils.currencyFormat.format(widget.bill.serviceFee),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: AppSize.asd),
                    SizedBox(
                      width: 70,
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixText: "%",
                        ),
                        onChanged: (value) {
                          final percentage = double.tryParse(value);
                          if (percentage != null && percentage >= 0) {
                            final state = context.findAncestorStateOfType<SummaryScreenState>();
                            if (state != null) {
                              state.setState(() {
                                state.serviceFeePercentage = percentage;
                              });
                              state.updateServiceFee();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  FormatterUtils.currencyFormat.format(widget.bill.total),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}