import 'package:flutter/material.dart';

class ProductSelectionDialog extends StatefulWidget {
  final String productName;
  final double unitPrice;

  const ProductSelectionDialog({
    Key? key,
    required this.productName,
    required this.unitPrice,
  }) : super(key: key);

  @override
  State<ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  int _quantity = 1;

  double get _subtotal => widget.unitPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Quantidade de ${widget.productName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
              ),
              Text('$_quantity', style: const TextStyle(fontSize: 18)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => _quantity++),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Subtotal: R\$ ${_subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop<Map<String, dynamic>>(context, {
            'quantity': _quantity,
            'subtotal': _subtotal,
          }),
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
