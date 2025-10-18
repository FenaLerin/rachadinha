import "package:flutter/foundation.dart";

@immutable
class Bill {
  final String name;
  final List<String> participants;
  final List<BillItem> items;
  final double serviceFeePercentage;

  Bill({
    required this.name,
    required this.participants,
    List<BillItem>? items,
    this.serviceFeePercentage = 10.0,
  }) : items = items ?? [];

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get serviceFee => subtotal * (serviceFeePercentage / 100);
  double get total => subtotal + serviceFee;

  Map<String, double> get valuePerPerson {
    final values = <String, double>{};
    for (final participant in participants) {
      double participantTotal = 0;
      for (final item in items) {
        if (item.participants.contains(participant)) {
          participantTotal += item.pricePerPerson;
        }
      }
      values[participant] = participantTotal;
    }
    return values;
  }

  Bill copyWith({
    String? name,
    List<String>? participants,
    List<BillItem>? items,
    double? serviceFeePercentage,
  }) {
    return Bill(
      name: name ?? this.name,
      participants: participants ?? this.participants,
      items: items ?? this.items,
      serviceFeePercentage: serviceFeePercentage ?? this.serviceFeePercentage,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'participants': participants,
      'items': items.map((item) => item.toJson()).toList(),
      'serviceFeePercentage': serviceFeePercentage,
    };
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      name: json['name'],
      participants: List<String>.from(json['participants']),
      items: (json['items'] as List).map((item) => BillItem.fromJson(item)).toList(),
      serviceFeePercentage: json['serviceFeePercentage'] ?? 10.0,
    );
  }
}

@immutable
class BillItem {
  final String name;
  final double unitPrice;
  final int quantity;
  final List<String> participants;


  const BillItem({
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.participants,
  });

  double get totalPrice => unitPrice * quantity;
  double get pricePerPerson => participants.isEmpty ? 0 : totalPrice / participants.length;

  BillItem copyWith({
    String? name,
    double? unitPrice,
    int? quantity,
    List<String>? participants,
  }) {
    return BillItem(
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      participants: participants ?? this.participants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'participants': participants,
    };
  }

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      name: json['name'],
      unitPrice: json['unitPrice'],
      quantity: json['quantity'],
      participants: List<String>.from(json['participants']),
    );
  }
}
