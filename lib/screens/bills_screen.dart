import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rachadinha/models/bill.dart';
import 'package:rachadinha/screens/bill_details_screen.dart';
import 'package:rachadinha/screens/create_bill_screen.dart';
import 'package:rachadinha/utils/app_size.dart';
import 'package:rachadinha/widgets/bill/bill_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillsScreen extends StatefulWidget {
  // const BillsScreen({super.key});
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const BillsScreen({
    required this.isDarkMode,
    required this.onToggleTheme,
    super.key,
  });

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  List<Bill> _bills = [];

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recarrega as comandas quando a tela recebe foco novamente
    _loadBills();
  }

  void _loadBills() async {
    final prefs = await SharedPreferences.getInstance();
    final billsJson = prefs.getStringList('bills') ?? [];
    setState(() {
      _bills = billsJson.map((jsonString) => Bill.fromJson(json.decode(jsonString))).toList();
    });
  }

  void _saveBills() async {
    final prefs = await SharedPreferences.getInstance();
    final billsJson = _bills.map((bill) => json.encode(bill.toJson())).toList();
    prefs.setStringList('bills', billsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comandas"),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: _bills.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: AppSize.asd),
                  Text(
                    "Nenhuma comanda ainda",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSize.asd),
              itemCount: _bills.length,
              itemBuilder: (context, index) {
                final bill = _bills[index];
                return BillCard(
                  bill: bill,
                  onDelete: () {
                    setState(() {
                      _bills.removeAt(index);
                      _saveBills();
                    });
                  },
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BillDetailsScreen(bill: bill),
                      ),
                    ).then((_) {
                      _loadBills();
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Bill>(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateBillScreen(),
            ),
          );
          
          if (result != null) {
            setState(() {
              _bills.add(result);
              _saveBills();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
