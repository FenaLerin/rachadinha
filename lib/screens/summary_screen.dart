import "dart:convert";

import "package:flutter/material.dart";
import "package:rachadinha/models/bill.dart";
import "package:rachadinha/utils/app_size.dart";
import "package:rachadinha/widgets/app/custom_appbar.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../utils/textfield/formatter/formatter_utils.dart";
import "../widgets/summary/person_list_summary.dart";
import "../widgets/summary/total_card_sumary.dart";

class SummaryScreen extends StatefulWidget {
  final Bill bill;

  const SummaryScreen({
    super.key,
    required this.bill,
  });

  @override
  State<SummaryScreen> createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  late double serviceFeePercentage;

  void updateServiceFee() async {
    final prefs = await SharedPreferences.getInstance();
    final billsJson = prefs.getStringList('bills') ?? [];
    final index = billsJson.indexWhere((jsonString) {
      final billMap = json.decode(jsonString);
      return billMap['name'] == widget.bill.name;
    });

    if (index != -1) {
      final updatedBill = Bill(
        name: widget.bill.name,
        participants: widget.bill.participants,
        items: widget.bill.items,
        serviceFeePercentage: serviceFeePercentage,
      );
      billsJson[index] = json.encode(updatedBill.toJson());
      prefs.setStringList('bills', billsJson);
    }
  }

  @override
  void initState() {
    super.initState();
    serviceFeePercentage = widget.bill.serviceFeePercentage;
  }

  @override
  Widget build(BuildContext context) {
    final bill = widget.bill.copyWith(
      serviceFeePercentage: serviceFeePercentage,
    );

    return Scaffold(
      appBar: CustomAppbar(title: "Resumo - ${bill.name}"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.asd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TotalCard(bill: bill),
            const SizedBox(height: AppSize.asd * 2),
            Text(
              "Lista de Itens",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSize.asd),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: bill.items.length,
              itemBuilder: (context, index) {
                final item = bill.items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.name),
                  subtitle: Text(
                    "${item.quantity}x ${FormatterUtils.currencyFormat.format(item.unitPrice)}",
                  ),
                  trailing: Text(
                    FormatterUtils.currencyFormat.format(item.totalPrice),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              },
            ),
            const SizedBox(height: AppSize.asd * 2),
            Text(
              "Valores por Pessoa",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSize.asd),
            PersonListSummary(bill: bill),
          ],
        ),
      ),
    );
  }
}
