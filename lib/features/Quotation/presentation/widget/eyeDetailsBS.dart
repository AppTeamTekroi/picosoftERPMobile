import 'package:flutter/material.dart';
import 'package:mobile_erp/ui/Buttons/CustomButton.dart';
import 'package:mobile_erp/ui/color/appColor.dart';

class EyeDetailsBottomSheet extends StatefulWidget {
  @override
  State<EyeDetailsBottomSheet> createState() => _EyeDetailsBottomSheetState();
}

class _EyeDetailsBottomSheetState extends State<EyeDetailsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.48,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22), topRight: Radius.circular(22))),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                height: 2,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                'Add Eye Details',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: width,
              height: 1,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Left Eye : ',
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

                children: const [
                  TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text('Sph.',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text('Cyl.',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text('Axis',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text('Vision',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                      )
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [
                      TextField(
                          textAlign: TextAlign.center,
                          minLines: 1,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: 'Sph.',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            border: InputBorder.none,
                          )),
                    ]),
                    Column(children: [
                      TextField(
                          textAlign: TextAlign.center,
                          minLines: 1,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              hintText: 'Cyl.',
                              border: InputBorder.none)),
                    ]),
                    Column(children: [
                      TextField(
                          textAlign: TextAlign.center,
                          minLines: 1,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: 'Axis',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            border: InputBorder.none,
                          )),
                    ]),
                    Column(children: [
                      TextField(
                          minLines: 1,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              hintText: 'Vision',
                              border: InputBorder.none)),
                    ]),
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Right Eye : ',
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

                children: const [
                  TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text('Sph.',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text('Cyl.',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text('Axis',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Text('Vision',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500)),
                      )
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [
                      TextField(
                          textAlign: TextAlign.center,
                          minLines: 1,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: 'Sph.',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            border: InputBorder.none,
                          )),
                    ]),
                    Column(children: [
                      TextField(
                          textAlign: TextAlign.center,
                          minLines: 1,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              hintText: 'Cyl.',
                              border: InputBorder.none)),
                    ]),
                    Column(children: [
                      TextField(
                          textAlign: TextAlign.center,
                          minLines: 1,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: 'Axis',
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                            border: InputBorder.none,
                          )),
                    ]),
                    Column(children: [
                      TextField(
                          minLines: 1,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              hintText: 'Vision',
                              border: InputBorder.none)),
                    ]),
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
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
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
}
