import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rachadinha/models/bill.dart';
import 'package:rachadinha/utils/app_size.dart';
import 'package:rachadinha/widgets/app/custom_appbar.dart';
import 'package:rachadinha/widgets/app/custom_textfield.dart';

class AddItemScreen extends StatefulWidget {
  final List<String> participants;

  const AddItemScreen({
    super.key,
    required this.participants,
  });

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  final _focusNode = FocusNode();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: "1");
  final _selectedParticipants = <String>{};

  @override
  void initState() {
    super.initState();
    _selectedParticipants.addAll(widget.participants);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _toggleParticipant(String participant) {
    setState(() {
      if (_selectedParticipants.contains(participant)) {
        _selectedParticipants.remove(participant);
      } else {
        _selectedParticipants.add(participant);
      }
    });
  }

  void _addItem() {
    final name = _nameController.text.trim();
    final priceText = _priceController.text.replaceAll('.', '').replaceAll(",", ".").replaceAll('R', '').replaceAll('\$', '').trim();
    final quantityText = _quantityController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite o nome do item"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite um preço válido"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite uma quantidade válida"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_selectedParticipants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione pelo menos um participante"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final item = BillItem(
      name: name,
      unitPrice: price,
      quantity: quantity,
      participants: _selectedParticipants.toList(),
    );

    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Adicionar Item"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSize.asd),
            CustomTextField(
              textEditingController: _nameController,
              label: "Nome do Item",
              textInputType: TextInputType.name,
              textInputAction: TextInputAction.next,
              focusNode: _focusNode,
            ),
            const SizedBox(height: AppSize.asd),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    textEditingController: _priceController,
                    label: "Preço Unitário",
                    textInputType: TextInputType.numberWithOptions(decimal: true),
                    mask: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                        if (text.isEmpty) return newValue.copyWith(text: '');

                        double value = double.parse(text) / 100;
                        final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
                        String newText = formatter.format(value);

                        return TextEditingValue(
                          text: newText,
                          selection: TextSelection.collapsed(offset: newText.length),
                        );
                      })
                    ],
                    hintText: "R\$ ",
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(width: AppSize.asd),
                Expanded(
                  child: CustomTextField(
                    textEditingController: _quantityController,
                    label: "Qtd",
                    textInputType: TextInputType.number,
                    mask: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.asd),
            Padding(
              padding: const EdgeInsets.all(AppSize.asd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Participantes",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            if (_selectedParticipants.length == widget.participants.length) {
                              _selectedParticipants.clear();
                            } else {
                              _selectedParticipants.addAll(widget.participants);
                            }
                          });
                        },
                        icon: Icon(
                          _selectedParticipants.length == widget.participants.length
                              ? Icons.deselect
                              : Icons.select_all,
                        ),
                        label: Text(
                          _selectedParticipants.length == widget.participants.length
                              ? "Desmarcar Todos"
                              : "Selecionar Todos",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSize.asd),
                  Wrap(
                      spacing: AppSize.asd / 2,
                      runSpacing: AppSize.asd / 2,
                      children: widget.participants.map((participant) {
                        final isSelected = _selectedParticipants.contains(participant);
                        return FilterChip(
                          label: Text(participant),
                          selected: isSelected,
                          onSelected: (selected) => _toggleParticipant(participant),
                        );
                      }).toList(),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSize.asd),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _addItem,
              label: const Text("Adicionar"),
              icon: const Icon(Icons.check),
            ),
          ),
        ),
      ),
    );
  }
}
