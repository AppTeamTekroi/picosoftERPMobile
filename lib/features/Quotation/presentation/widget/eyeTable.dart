import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_erp/features/orders/controller/OrderListController.dart';

import '../../controller/quotation_controller.dart';

class EyeDetailsTable extends StatelessWidget {
  final String eye;

  const EyeDetailsTable({
    Key? key,
    required this.eye,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuotationController qc = Get.find<QuotationController>();

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              '$eye Eye : ',
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
                    _buildBoldTableCell('Sph.'),
                    _buildBoldTableCell('Cyl.'),
                    _buildBoldTableCell('Axis'),
                    _buildBoldTableCell('Vision'),
                  ],
                ),
                TableRow(
                  children: [
                    _buildTableCell(
                        eye == "Left"
                            ? qc.left_sph.toString()
                            : qc.right_sph.toString(),
                        // ? oc.prescription.value.l_sph.toString()
                        // : oc.prescription.value.r_sph.toString(),
                        "Sph."),
                    _buildTableCell(
                        eye == "Left"
                            ? qc.left_cyl.toString()
                            : qc.right_cyl.toString(),
                        // ? oc.prescription.value.l_cyl.toString()
                        // : oc.prescription.value.r_cyl.toString(),
                        "Cyl."),
                    _buildTableCell(
                        eye == "Left"
                            ? qc.left_axis.toString()
                            : qc.right_axis.toString(),
                        // ? oc.prescription.value.l_axis.toString()
                        // : oc.prescription.value.r_axis.toString(),
                        "Axis"),
                    _buildTableCell(
                        eye == "Left"
                            ? qc.left_vision.toString()
                            : qc.right_vision.toString(),
                        // ? oc.prescription.value.l_vision.toString()
                        // : oc.prescription.value.r_vision.toString(),
                        "Vision"),
                  ],
                ),
                // TableRow(
                //   children: [
                //     _buildTableCell(
                //         eye == "Left" ? qc.left_sph.value : qc.right_sph.value,
                //         "Sph."),
                //     _buildTableCell(
                //         eye == "Left" ? qc.left_cyl.value : qc.right_cyl.value,
                //         "Cyl."),
                //     _buildTableCell(
                //         eye == "Left"
                //             ? qc.left_axis.value
                //             : qc.right_axis.value,
                //         "Axis"),
                //     _buildTableCell(
                //         eye == "Left"
                //             ? qc.left_vision.value
                //             : qc.right_vision.value,
                //         "Vision"),
                //   ],
                // ),
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
