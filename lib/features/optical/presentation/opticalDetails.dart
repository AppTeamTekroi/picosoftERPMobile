import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/Quotation/controller/quotation_controller.dart';
import 'package:mobile_erp/ui/Buttons/CustomButton.dart';
import 'package:mobile_erp/ui/color/appColor.dart';

class OpticalDetailScreen extends StatefulWidget {
  const OpticalDetailScreen({super.key});

  @override
  State<OpticalDetailScreen> createState() => _OpticalDetailScreenState();
}

class _OpticalDetailScreenState extends State<OpticalDetailScreen> {
  bool isEyesSame = false;
  QuotationController qc = Get.put(QuotationController());

  String left_sph = '';
  String left_cyl = '';
  String left_axis = '';
  String left_vision = '';
  String right_sph = '';
  String right_cyl = '';
  String right_axis = '';
  String right_vision = '';
  String add = '';
  String pd = '';
  String optometrist = '';

  late TextEditingController left_sphController;
  late TextEditingController left_cylController;
  late TextEditingController left_axisController;
  late TextEditingController left_visionController;
  late TextEditingController right_sphController;
  late TextEditingController right_cylController;
  late TextEditingController right_axisController;
  late TextEditingController right_visionController;
  late TextEditingController addController;
  late TextEditingController pdController;
  late TextEditingController optometricsController;

  void initState() {
    super.initState();
    left_sph = qc.left_sph.value;
    left_cyl = qc.left_cyl.value;
    left_axis = qc.left_axis.value;
    left_vision = qc.left_vision.value;
    right_sph = qc.right_sph.value;
    right_cyl = qc.right_cyl.value;
    right_axis = qc.right_axis.value;
    right_vision = qc.right_vision.value;
    add = qc.add.value;
    pd = qc.pd.value;
    optometrist = qc.optometrics.value;
    left_sphController = TextEditingController(text: qc.left_sph.value);
    left_cylController = TextEditingController(text: qc.left_cyl.value);
    left_axisController = TextEditingController(text: qc.left_axis.value);
    left_visionController = TextEditingController(text: qc.left_vision.value);
    right_sphController = TextEditingController(text: qc.right_sph.value);
    right_cylController = TextEditingController(text: qc.right_cyl.value);
    right_axisController = TextEditingController(text: qc.right_axis.value);
    right_visionController = TextEditingController(text: qc.right_vision.value);
    addController = TextEditingController(text: qc.add.value);
    pdController = TextEditingController(text: qc.pd.value);
    optometricsController = TextEditingController(text: qc.optometrics.value);
  }

  void dispose() {
    left_sphController.dispose();
    left_cylController.dispose();
    left_axisController.dispose();
    left_visionController.dispose();
    right_sphController.dispose();
    right_cylController.dispose();
    right_axisController.dispose();
    right_visionController.dispose();
    addController.dispose();
    pdController.dispose();
    optometricsController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text('Optical Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Checkbox(
                    value: isEyesSame,
                    onChanged: (value) {
                      setState(() {
                        isEyesSame = value!;
                      });
                    },
                  ),
                  Text('Both Eyes same?'),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      !isEyesSame?'Left Eye : ':'Eye : ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Table(
                      // defaultColumnWidth: FixedColumnWidth(120.0),
                      border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1,
                          borderRadius: BorderRadius.circular(5)),

                      children: [
                        TableRow(children: [
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Sph.',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Cyl.',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Axis',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Vision',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: left_sphController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                hintText: 'Sph.',
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 5),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                left_sph = val;
                              },
                            ),
                          ]),
                          Column(children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: left_cylController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                                  hintText: 'Cyl.',
                                  border: InputBorder.none),
                              onChanged: (val) {
                                left_cyl = val;
                              },
                            ),
                          ]),
                          Column(children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: left_axisController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                hintText: 'Axis',
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 5),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                left_axis = val;
                              },
                            ),
                          ]),
                          Column(children: [
                            TextField(
                              minLines: 1,
                              controller: left_visionController,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                                  hintText: 'Vision',
                                  border: InputBorder.none),
                              onChanged: (val) {
                                left_vision = val;
                              },
                            ),
                          ]),
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Right Eye : ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ), visible: !isEyesSame,),
                  Visibility(child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Table(
                      // defaultColumnWidth: FixedColumnWidth(120.0),
                      border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1,
                          borderRadius: BorderRadius.circular(5)),

                      children: [
                        TableRow(children: [
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Sph.',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Cyl.',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Axis',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Vision',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: right_sphController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                hintText: 'Sph.',
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 5),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                right_sph = val;
                              },
                            ),
                          ]),
                          Column(children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: right_cylController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                                  hintText: 'Cyl.',
                                  border: InputBorder.none),
                              onChanged: (val) {
                                right_cyl = val;
                              },
                            ),
                          ]),
                          Column(children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: right_axisController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                hintText: 'Axis',
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 5),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                right_axis = val;
                              },
                            ),
                          ]),
                          Column(children: [
                            TextField(
                              controller: right_visionController,
                              minLines: 1,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                                  hintText: 'Vision',
                                  border: InputBorder.none),
                              onChanged: (val) {
                                right_vision = val;
                              },
                            ),
                          ]),
                        ]),
                      ],
                    ),
                  ), visible: !isEyesSame,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Additional Details: ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Table(
                      // defaultColumnWidth: FixedColumnWidth(120.0),
                      border: TableBorder.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1,
                          borderRadius: BorderRadius.circular(5)),

                      children: [
                        TableRow(children: [
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Add.',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('PD',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text('Optometrist',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500)),
                            )
                          ]),
                        ]),
                        TableRow(children: [
                          Column(children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: addController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                hintText: 'Add.',
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 5),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                add = val;
                              },
                            ),
                          ]),
                          Column(children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: pdController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                                  hintText: 'PD',
                                  border: InputBorder.none),
                              onChanged: (val) {
                                pd = val;
                              },
                            ),
                          ]),
                          Column(children: [
                            TextField(
                              textAlign: TextAlign.center,
                              controller: optometricsController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14.0),
                              decoration: InputDecoration(
                                hintText: 'Optometrist',
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 5),
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                optometrist = val;
                              },
                            ),
                          ]),
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Spacer(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomButton(
                    height: 53,
                    title: 'Save & Continue',
                    buttonText: Text(
                      'Save & Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    backgroundColor: AppColors.mainblue,
                    borderRadius: 15,
                    onPressed: () {
                      // Go back to the previous screen
                      if(isEyesSame) {
                        qc.left_sph.value = left_sph;
                        qc.left_cyl.value = left_cyl;
                        qc.left_axis.value = left_axis;
                        qc.left_vision.value = left_vision;
                        qc.right_sph.value = left_sph;
                        qc.right_cyl.value = left_cyl;
                        qc.right_axis.value = left_axis;
                        qc.right_vision.value = left_vision;
                      }
                      else {
                        qc.left_sph.value = left_sph;
                        qc.left_cyl.value = left_cyl;
                        qc.left_axis.value = left_axis;
                        qc.left_vision.value = left_vision;
                        qc.right_sph.value = right_sph;
                        qc.right_cyl.value = right_cyl;
                        qc.right_axis.value = right_axis;
                        qc.right_vision.value = right_vision;
                      }
                      qc.add.value = add;
                      qc.pd.value = pd;
                      qc.optometrics.value = optometrist;
                      Get.back();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
