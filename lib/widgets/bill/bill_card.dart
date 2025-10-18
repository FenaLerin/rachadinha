import 'package:rachadinha/models/bill.dart';
import 'package:rachadinha/utils/app_size.dart';
import 'package:flutter/material.dart';

import '../../utils/textfield/formatter/formatter_utils.dart';
import '../app/confirm_dialog.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const BillCard({
    super.key,
    required this.bill,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSize.asd),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSize.asd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bill.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ConfirmDialog.show(
                      context,
                      message: "Tem certeza que deseja deletar a comanda \"${bill.name}\"?",
                      onConfirm: onDelete,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.asd / 2),
              Wrap(
                spacing: AppSize.asd / 2,
                runSpacing: AppSize.asd / 2,
                children: bill.participants.map((participant) => Chip(
                  label: Text(participant),
                )).toList(),
              ),
              const SizedBox(height: AppSize.asd / 2),
              Text(
                "Total: ${FormatterUtils.currencyFormat.format(bill.total)}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}