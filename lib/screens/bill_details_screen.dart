import "dart:convert";

import "package:flutter/material.dart";
import "package:rachadinha/models/bill.dart";
import "package:rachadinha/screens/add_item_screen.dart";
import "package:rachadinha/screens/summary_screen.dart";
import "package:rachadinha/utils/app_size.dart";
import "package:rachadinha/widgets/app/custom_appbar.dart";
import "package:rachadinha/widgets/app/custom_line_widget.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../utils/textfield/formatter/formatter_utils.dart";
import "../widgets/app/confirm_dialog.dart";

class BillDetailsScreen extends StatefulWidget {
  final Bill bill;

  const BillDetailsScreen({
    super.key,
    required this.bill,
  });

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  late Bill _bill;

  @override
  void initState() {
    super.initState();
    _bill = widget.bill;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBill();
  }

  void _loadBill() async {
    final prefs = await SharedPreferences.getInstance();
    final billsJson = prefs.getStringList('bills') ?? [];
    final index = billsJson.indexWhere((jsonString) {
      final billMap = json.decode(jsonString);
      return billMap['name'] == widget.bill.name;
    });
    
    if (index != -1) {
      final updatedBill = Bill.fromJson(json.decode(billsJson[index]));
      if (mounted) {
        setState(() {
          _bill = updatedBill;
        });
      }
    }
  }

  void _addItem(BillItem item) {
    setState(() {
      _bill = _bill.copyWith(
        items: [..._bill.items, item],
      );
      _saveBill();
    });
  }

  void _removeItem(BillItem item) {
    setState(() {
      _bill = _bill.copyWith(
        items: _bill.items.where((i) => i != item).toList(),
      );
      _saveBill();
    });
  }

  void _saveBill() async {
    final prefs = await SharedPreferences.getInstance();
    final billsJson = prefs.getStringList('bills') ?? [];
    
    // Encontra o índice da comanda atual na lista
    int index = -1;
    for (int i = 0; i < billsJson.length; i++) {
      final billMap = json.decode(billsJson[i]);
      if (billMap['name'] == widget.bill.name) {
        index = i;
        break;
      }
    }
    
    if (index != -1) {
      billsJson[index] = json.encode(_bill.toJson());
      prefs.setStringList('bills', billsJson);
    } else {
      // Se não encontrou, adiciona como nova comanda
      billsJson.add(json.encode(_bill.toJson()));
      prefs.setStringList('bills', billsJson);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: _bill.name),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSize.asd),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoCard(
                  icon: Icons.people_outline,
                  label: "Participantes",
                  value: _bill.participants.length.toString(),
                ),
                _InfoCard(
                  icon: Icons.receipt_long_outlined,
                  label: "Itens",
                  value: _bill.items.length.toString(),
                ),
              ],
            ),
          ),
          _bill.items.isEmpty ? const SizedBox.shrink() : _ShowSummaryButton(bill: _bill, loadBill: _loadBill,),
          Expanded(
            child: _bill.items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.receipt_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: AppSize.asd),
                        Text(
                          "Nenhum item adicionado",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSize.asd),
                    itemCount: _bill.items.length,
                    separatorBuilder: (context, index) => Divider(color: Theme.of(context).colorScheme.inversePrimary),
                    itemBuilder: (context, index) {
                      final item = _bill.items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item.name),
                        subtitle: Text(
                          "${item.quantity}x ${FormatterUtils.currencyFormat.format(item.unitPrice)}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              FormatterUtils.currencyFormat.format(item.totalPrice),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(width: AppSize.asd),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => ConfirmDialog.show(
                                context,
                                message: "Tem certeza que deseja deletar o item \"${item.name}\"?",
                                onConfirm: () => _removeItem(item)
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => _ItemDetailsBottomSheet(item: item),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSize.asd),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () async {
                final result = await Navigator.push<BillItem>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemScreen(
                      participants: _bill.participants,
                    ),
                  ),
                );

                if (result != null) {
                  _addItem(result);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Adicionar Item"),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(height: AppSize.asd / 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class _ShowSummaryButton extends StatelessWidget {
  final Bill bill;
  final Function loadBill;

  const _ShowSummaryButton({
    required this.bill,
    required this.loadBill,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.asd),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SummaryScreen(bill: bill),
              ),
            );
            
            loadBill();
          },
          label: const Text("Ver Resumo"),
          icon: const Icon(Icons.summarize),
        )
      )
    );
  }
}

class _ItemDetailsBottomSheet extends StatelessWidget {
  final BillItem item;

  const _ItemDetailsBottomSheet({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
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
              item.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSize.asd),
            CustomLineWidget(),
            const SizedBox(height: AppSize.asd),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quantidade:"),
                Text("${item.quantity}x"),
              ],
            ),
            const SizedBox(height: AppSize.asd / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Preço unitário:"),
                Text(FormatterUtils.currencyFormat.format(item.unitPrice)),
              ],
            ),
            const SizedBox(height: AppSize.asd / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total:"),
                Text(
                  FormatterUtils.currencyFormat.format(item.totalPrice),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSize.asd * 2),
            Text(
              "Participantes (${item.participants.length})",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSize.asd / 2),
            Wrap(
              spacing: AppSize.asd / 2,
              runSpacing: AppSize.asd / 2,
              children: item.participants.map((participant) => Chip(
                label: Text(participant),
              )).toList(),
            ),
            if (item.participants.isNotEmpty) ...[
              const SizedBox(height: AppSize.asd / 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Valor por pessoa:"),
                  Text(
                    FormatterUtils.currencyFormat.format(item.pricePerPerson),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSize.asd * 2),
          ],
        ),
      ),
    );
  }
}
