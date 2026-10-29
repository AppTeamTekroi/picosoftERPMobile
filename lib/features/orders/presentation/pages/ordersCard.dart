import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/getOrderPlacedModel.dart';

class orders_card extends StatelessWidget {
  orders_card(
      {super.key,
        required this.width,
        required this.height,
        required this.index});

  final double width;
  final double height;
  final GetOrderPlacedModel index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: width * 0.01),
      height: height * 0.135,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Column(
        children: [
          Container(
            width: width,
            height: height * 0.08,
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        index.customer?.name ?? '',
                        style: TextStyle(
                            fontSize: height * 0.017,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${index.strOrderSeries} ",
                        style: TextStyle(
                            fontSize: height * 0.013,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: height * 0.020,
                      width: 70,
                      decoration: BoxDecoration(
                          color: index.orderStatus==0?Color(0xffdbc300):index.orderStatus==1?Colors.green:Colors.red,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(10))),
                      child: Center(
                        child: Text(
                            index.orderStatus==0?'PENDING':index.orderStatus==1?'PAID':'CANCELLED',
                            style: TextStyle(
                                fontSize: height * 0.012,
                                color: index.orderpayments==null?Color.fromARGB(255, 52, 36, 31):index.orderpayments!.isEmpty?Color.fromARGB(255, 52, 36, 31):Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Text(
                      '₹${index.totalAmount}',
                      style: TextStyle(
                          fontSize: height * 0.02, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          Container(
            width: width,
            height: height * 0.04,
            // color: Colors.yellow,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(formatDateTime(index.createdAt.toString()),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: height * 0.013,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  SizedBox(
                      height: 20,
                      child: Image.asset(
                        'lib/ui/assets/whatsapp.png',
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      print('More button pressed');
                    },
                    child: const Icon(
                      Icons.more_horiz,
                      size: 34,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

String formatDateTime(String date) {
  // date = "2024-04-05T14:18:15.000000Z"
  // extract date, month and year and return it in the format "05-04-2024"
  return "${date.substring(8, 10)}-${date.substring(5, 7)}-${date.substring(0, 4)}";
}