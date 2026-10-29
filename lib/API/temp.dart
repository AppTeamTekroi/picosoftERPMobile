import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  var record_payment_amout = 0.0.obs;
  var record_payment_type = 'UPI'.obs;
  var record_payment_settlement = '1'.obs;
}

class PaymentDialog extends StatelessWidget {
  final PaymentController oc = Get.put(PaymentController());
  final TextEditingController amountController = TextEditingController();

  PaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Dialog Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.defaultDialog(
              title: 'Payment Details',
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                      ),
                      onChanged: (value) {
                        oc.record_payment_amout.value = double.parse(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: oc.record_payment_type.value,
                      items: ['UPI', 'Cash', 'Card'].map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Payment Type',
                      ),
                      onChanged: (newValue) {
                        oc.record_payment_type.value = newValue!;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: oc.record_payment_settlement.value,
                      items: ['1', '2', '3'].map((String settlement) {
                        return DropdownMenuItem<String>(
                          value: settlement,
                          child: Text(settlement),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Payment Settlement',
                      ),
                      onChanged: (newValue) {
                        oc.record_payment_settlement.value = newValue!;
                      },
                    ),
                  ],
                ),
              ),
              textCancel: 'Cancel',
              textConfirm: 'Proceed',
              onConfirm: () {
                Navigator.of(context).pop();
                // Handle the proceed action here
              },
            );
          },
          child: const Text('Show Dialog'),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    GetMaterialApp(
      home: PaymentDialog(),
    ),
  );
}
