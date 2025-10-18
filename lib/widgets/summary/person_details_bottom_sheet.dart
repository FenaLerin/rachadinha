import "package:flutter/material.dart";
import "package:rachadinha/models/bill.dart";
import "package:rachadinha/utils/app_size.dart";

import "../../utils/textfield/formatter/formatter_utils.dart";
import "../app/custom_line_widget.dart";

class PersonDetailsBottomSheet extends StatelessWidget {
  final Bill bill;
  final String personName;

  const PersonDetailsBottomSheet({super.key, 
    required this.bill,
    required this.personName,
  });

  @override
  Widget build(BuildContext context) {
    final personItems = bill.items
        .where((item) => item.participants.contains(personName))
        .toList();

    final subtotal = personItems.fold<double>(
      0,
      (sum, item) => sum + item.pricePerPerson,
    );

    final serviceFee = subtotal * (bill.serviceFeePercentage / 100);
    final total = subtotal + serviceFee;

    return Container(
      padding: const EdgeInsets.all(AppSize.asd * 1.5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              personName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSize.asd),
            const CustomLineWidget(),
            const SizedBox(height: AppSize.asd),

            personItems.isEmpty
              ? Center(
                child: Text(
                  "Nenhum item consumido.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
              : Column(
                children: personItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSize.asd / 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          FormatterUtils.currencyFormat.format(item.pricePerPerson),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: AppSize.asd),
            const CustomLineWidget(),
            const SizedBox(height: AppSize.asd),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal:"),
                Text(FormatterUtils.currencyFormat.format(subtotal)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Taxa de serviço (${bill.serviceFeePercentage.toStringAsFixed(0)}%):"),
                Text(FormatterUtils.currencyFormat.format(serviceFee)),
              ],
            ),
            const SizedBox(height: AppSize.asd / 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  FormatterUtils.currencyFormat.format(total),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSize.asd * 2),
          ],
        ),
      ),
    );
  }
}