import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/orders/controller/OrderListController.dart';
import '../../controller/quotation_controller.dart';

class AdditionalDetailsTable extends StatefulWidget {
  AdditionalDetailsTable({Key? key}) : super(key: key);

  @override
  State<AdditionalDetailsTable> createState() => _AdditionalDetailsTableState();
}

class _AdditionalDetailsTableState extends State<AdditionalDetailsTable> {
  Widget build(BuildContext context) {
    QuotationController qc = Get.find<QuotationController>();

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              'Additional Details : ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Table(
              border: TableBorder.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 1,
                borderRadius: BorderRadius.circular(5),
              ),
              children: [
                TableRow(
                  children: [
                    _buildBoldTableCell('Add'),
                    _buildBoldTableCell('PD'),
                    _buildBoldTableCell('Optometrics'),
                  ],
                ),
                TableRow(
                  children: [
                    // _buildTableCell(oc.prescription.value.add.toString(), "Add"),
                    // _buildTableCell(oc.prescription.value.pd.toString(), "PD"),
                    // _buildTableCell(oc.prescription.value.optometrics??'', "Optometrics"),
                    _buildTableCell(qc.add.toString(), "Add"),
                    _buildTableCell(qc.pd.toString(), "PD"),
                    _buildTableCell(
                        qc.optometrics.toString() ?? '', "Optometrics"),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    });
  }

  Widget _buildBoldTableCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, String field) {
    var displayText = text.isNotEmpty ? text : field;
    if (displayText == "null" ||
        displayText == "Null" ||
        displayText == "null" ||
        displayText == "NULL" ||
        displayText == "") {
      displayText = "0";
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        displayText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    );
  }
}
