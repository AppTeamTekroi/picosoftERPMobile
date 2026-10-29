import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_erp/features/orders/controller/OrderListController.dart';
import 'package:mobile_erp/features/orders/presentation/pages/orderdetail.dart';
import 'package:mobile_erp/features/orders/presentation/pages/ordersCard.dart';
import 'package:mobile_erp/ui/color/appColor.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({super.key});

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  OrderPlacedController oc = Get.put(OrderPlacedController());
  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    oc.getOrderPlacedList();
    super.initState();
  }

  @override
  void dispose() {
    oc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leadingWidth: 40,
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_sharp,
              size: 20,
            ),
          ),
        ),
        title: const Text('Orders List'),
        actions: const [],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            height: height * 0.18,
            width: MediaQuery.of(context).size.width * 0.94,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: height * 0.015),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: height * 0.08,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                      child: Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 147, 147, 147)),
                                ),
                                Text(
                                  "₹${oc.totalAmount.value}",
                                  style: TextStyle(
                                      fontSize: height * 0.025,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Paid',
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 147, 147, 147))),
                                Text(
                                  "₹${oc.paidAmount.value}",
                                  style: TextStyle(
                                      fontSize: height * 0.025,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Pending',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 147, 147, 147)),
                                ),
                                Text(
                                  "₹${oc.pendingAmount.value}",
                                  style: TextStyle(
                                      fontSize: height * 0.025,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 193, 193, 193),
                    height: 2,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'This Year',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * 0.02),
                              ),
                              const Icon(CupertinoIcons.pen)
                            ],
                          ),
                          const Text(
                            "Starting date - ending date",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_alt_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            CupertinoIcons.search,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TabBar(
                      splashBorderRadius:
                          BorderRadius.all(Radius.circular(20)),
                      dividerColor: Colors.transparent,
                      tabs: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Tab(text: "All Transaction"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Tab(text: "Paid"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Tab(text: "Pending"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Tab(text: "Cancelled"),
                        ),
                      ],
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                          color: AppColors.mainblue, // Color of the indicator
                          borderRadius: BorderRadius.all(
                              Radius.circular(20)) // Rounded corners
                          ),
                      unselectedLabelColor: AppColors.mainblue,
                      unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.normal),
                      isScrollable: true,
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      // labelPadding: EdgeInsets.symmetric(
                      //   horizontal: 32,
                      // ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      Obx(() {
                        return oc.detailLoading.value == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.blue,
                                strokeWidth: 1,
                              ))
                            : oc.orderPlacedList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: oc.orderPlacedList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 7),
                                          child: InkWell(
                                              onTap: () {
                                                print('Order Card Pressed');

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsPage(
                                                      id: oc
                                                          .orderPlacedList[
                                                              index]
                                                          .id
                                                          .toString(),
                                                      isOrderDetails: oc
                                                                  .orderPlacedList[
                                                                      index]
                                                                  .orderStatus ==
                                                              2
                                                          ? false
                                                          : true,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: orders_card(
                                                width: width,
                                                height: height,
                                                index:
                                                    oc.orderPlacedList[index],
                                              )));
                                    })
                                : const Center(
                                    child: Text('No Order Found'),
                                  );
                      }),
                      Obx(() {
                        return oc.detailLoading.value == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.blue,
                                strokeWidth: 1,
                              ))
                            : oc.paidOrderList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: oc.paidOrderList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 7),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsPage(
                                                      id: oc
                                                          .paidOrderList[index]
                                                          .id!
                                                          .toString(),
                                                      isOrderDetails: true,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: orders_card(
                                                width: width,
                                                height: height,
                                                index: oc.paidOrderList[index],
                                              )));
                                    })
                                : const Center(
                                    child: Text('No Order Found'),
                                  );
                      }),
                      Obx(() {
                        return oc.detailLoading.value == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.blue,
                                strokeWidth: 1,
                              ))
                            : oc.pendingOrderList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: oc.pendingOrderList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 7),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsPage(
                                                      id: oc
                                                          .pendingOrderList[
                                                              index]
                                                          .id!
                                                          .toString(),
                                                      isOrderDetails: true,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: orders_card(
                                                width: width,
                                                height: height,
                                                index:
                                                    oc.pendingOrderList[index],
                                              )));
                                    })
                                : const Center(
                                    child: Text('No Order Found'),
                                  );
                      }),
                      Obx(() {
                        return oc.detailLoading.value == true
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.blue,
                                strokeWidth: 1,
                              ))
                            : oc.cancelledOrderList.isNotEmpty
                                ? ListView.builder(
                                    itemCount: oc.cancelledOrderList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 7),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsPage(
                                                      id: oc
                                                          .cancelledOrderList[
                                                              index]
                                                          .id!
                                                          .toString(),
                                                      isOrderDetails: false,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: orders_card(
                                                width: width,
                                                height: height,
                                                index: oc
                                                    .cancelledOrderList[index],
                                              )));
                                    })
                                : const Center(
                                    child: Text('No Order Found'),
                                  );
                      }),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
