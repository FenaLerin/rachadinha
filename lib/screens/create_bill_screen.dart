import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rachadinha/models/bill.dart';
import 'package:rachadinha/utils/app_size.dart';
import 'package:rachadinha/widgets/app/custom_appbar.dart';
import 'package:rachadinha/widgets/app/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({super.key});

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final _nameController = TextEditingController();
  final _participantController = TextEditingController();
  final _focusNode = FocusNode();
  final _participantFocusNode = FocusNode();
  final List<String> _participants = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _addParticipant(String participant) {
    if (participant.trim().isEmpty) return;
    
    if (_participants.contains(participant.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Este participante já foi adicionado"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _participants.add(participant.trim());
      _participantController.clear();
    });
    _participantFocusNode.requestFocus();
  }

  void _removeParticipant(String participant) {
    setState(() {
      _participants.remove(participant);
    });
  }

  void _createBill() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Digite um nome para a comanda"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_participants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Adicione pelo menos um participante"),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final bill = Bill(
      name: _nameController.text.trim(),
      participants: List.from(_participants),
    );

    // Save the new bill to shared preferences
    final prefs = await SharedPreferences.getInstance();
    final billsJson = prefs.getStringList('bills') ?? [];
    billsJson.add(json.encode(bill.toJson()));
    prefs.setStringList('bills', billsJson);

    Navigator.pop(context, bill);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _participantController.dispose();
    _participantFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Nova Comanda"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSize.asd),
            CustomTextField(
              textEditingController: _nameController,
              label: "Nome da Comanda",
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              focusNode: _focusNode,
            ),
            const SizedBox(height: AppSize.asd * 2),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    textEditingController: _participantController,
                    focusNode: _participantFocusNode,
                    label: "Adicionar Participante",
                    textInputType: TextInputType.text,
                    onChange: (value) {
                      if (value.endsWith("\n")) {
                        _addParticipant(value.trim());
                      }
                    },
                    onFieldSubmitted: (value) {
                      _addParticipant(value);
                    },
                  ),
                ),
                const SizedBox(width: AppSize.asd),
                IconButton(
                  onPressed: () => _addParticipant(_participantController.text),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: AppSize.asd),
            if (_participants.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(AppSize.asd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Participantes",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSize.asd / 2),
                    Wrap(
                      spacing: AppSize.asd / 2,
                      runSpacing: AppSize.asd / 2,
                      children: _participants.map((participant) => Chip(
                        label: Text(participant),
                        onDeleted: () => _removeParticipant(participant),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSize.asd),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _createBill,
              label: const Text("Criar Comanda"),
              icon: const Icon(Icons.check),
            ),
          ),
        ),
      ),
    );
  }
}
