import "package:flutter/material.dart";
import "package:rachadinha/models/bill.dart";

import "../../utils/textfield/formatter/formatter_utils.dart";
import "person_details_bottom_sheet.dart";

class PersonListSummary extends StatelessWidget {
  final Bill bill;

  const PersonListSummary({
    super.key, 
    required this.bill,
  });

  @override
  Widget build(BuildContext context) {
    final valuePerPerson = bill.valuePerPerson;
    final fee = 1 + (bill.serviceFeePercentage / 100);
    final sortedParticipants = valuePerPerson.keys.toList()
      ..sort((a, b) => valuePerPerson[b]!.compareTo(valuePerPerson[a]!));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: sortedParticipants.length,
      itemBuilder: (context, index) {
        final participant = sortedParticipants[index];
        final value = valuePerPerson[participant]!;
        final valueWithFee = value * fee;
        final textValues = FormatterUtils.currencyFormat.format(valueWithFee);

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) => PersonDetailsBottomSheet(
                bill: bill,
                personName: participant,
              ),
            );
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(participant),
            trailing: Text(
              textValues,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
      },
    );
  }
}