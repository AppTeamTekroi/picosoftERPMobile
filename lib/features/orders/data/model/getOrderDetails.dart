class OrderDetailsModel {
  int? id;
  int? userId;
  int? customerId;
  int? prescriptionId;
  String? totalAmount;
  String? amount;
  String? totalGst;
  String? advanceAmount;
  String? discount;
  String? paymentType;
  String? paymentSettlement;
  String? paidAmount;
  int? orderStatus;
  int? storeId;
  String? strOrderSeries;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? paymentMethods;
  Customer? customer;
  List<OrderItem>? orderItems;
  List<OrderPayment>? orderPayments;

  OrderDetailsModel({
    this.id,
    this.userId,
    this.customerId,
    this.prescriptionId,
    this.totalAmount,
    this.amount,
    this.totalGst,
    this.advanceAmount,
    this.discount,
    this.paymentType,
    this.paymentSettlement,
    this.paidAmount,
    this.orderStatus,
    this.storeId,
    this.strOrderSeries,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.paymentMethods,
    this.customer,
    this.orderItems,
    this.orderPayments,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    var list = json['orderitems'] as List;
    List<OrderItem> orderItemsList =
        list.map((i) => OrderItem.fromJson(i)).toList();

    var paymentList = json['orderpayments'] as List;
    List<OrderPayment> orderPaymentsList =
        paymentList.map((i) => OrderPayment.fromJson(i)).toList();

    return OrderDetailsModel(
      id: json['id'],
      userId: json['user_id'],
      customerId: json['customer_id'],
      prescriptionId: json['prescription_id'],
      totalAmount: json['total_amount'],
      amount: json['amount'],
      totalGst: json['total_gst'],
      advanceAmount: json['advance_amount'],
      discount: json['discount'],
      paymentType: json['payment_type'],
      paymentSettlement: json['payment_settlement'],
      paidAmount: json['paid_amount'],
      orderStatus: json['order_status'],
      storeId: json['store_id'],
      strOrderSeries: json['str_order_series'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      paymentMethods: json['payment_methods'],
      customer: Customer.fromJson(json['customer']),
      orderItems: orderItemsList,
      orderPayments: orderPaymentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'customer_id': customerId,
      'prescription_id': prescriptionId,
      'total_amount': totalAmount,
      'amount': amount,
      'total_gst': totalGst,
      'advance_amount': advanceAmount,
      'discount': discount,
      'payment_type': paymentType,
      'payment_settlement': paymentSettlement,
      'paid_amount': paidAmount,
      'order_status': orderStatus,
      'store_id': storeId,
      'str_order_series': strOrderSeries,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'payment_methods': paymentMethods,
      'customer': customer?.toJson(),
      'orderitems': orderItems?.map((item) => item.toJson()).toList(),
      'orderpayments': orderPayments?.map((item) => item.toJson()).toList(),
    };
  }
}

class Customer {
  int? id;
  String? companyName;
  String? email;
  dynamic gstin;
  String? name;
  String? phone;
  int? openingBalance;
  dynamic addressId;
  dynamic storeId;
  String? createdAt;
  String? updatedAt;
  int? status;

  Customer({
    this.id,
    this.companyName,
    this.email,
    this.gstin,
    this.name,
    this.phone,
    this.openingBalance,
    this.addressId,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      companyName: json['company_name'],
      email: json['email'],
      gstin: json['gstin'],
      name: json['name'],
      phone: json['phone'],
      openingBalance: json['opening_balance'],
      addressId: json['address_id'],
      storeId: json['store_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'email': email,
      'gstin': gstin,
      'name': name,
      'phone': phone,
      'openingBalance': openingBalance,
      'addressId': addressId,
      'storeId': storeId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }
}

class OrderItem {
  int? id;
  int? orderId;
  int? productId;
  dynamic prescriptionId;
  int? quantities;
  String? price;
  String? gstAmount;
  String? totalAmount;
  String? discount;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic orderStatus;
  Product? product;

  OrderItem({
    this.id,
    this.orderId,
    this.productId,
    this.prescriptionId,
    this.quantities,
    this.price,
    this.gstAmount,
    this.totalAmount,
    this.discount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderStatus,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      prescriptionId: json['prescription_id'],
      quantities: json['quantities'],
      price: json['price'],
      gstAmount: json['gst_amount'],
      totalAmount: json['total_amount'],
      discount: json['discount'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      orderStatus: json['order_status'],
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
      'prescriptionId': prescriptionId,
      'quantities': quantities,
      'price': price,
      'gstAmount': gstAmount,
      'totalAmount': totalAmount,
      'discount': discount,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'orderStatus': orderStatus,
      'product': product,
    };
  }
}

class Product {
  int? id;
  String? name;
  String? stockPrice;
  String? barcode;
  String? description;
  int? tax;
  String? mrp;
  String? hsn;
  int? productCategoryId;
  int? itemTypeId;
  String? createdAt;
  String? updatedAt;
  int? status;

  Product({
    this.id,
    this.name,
    this.stockPrice,
    this.barcode,
    this.description,
    this.tax,
    this.mrp,
    this.hsn,
    this.productCategoryId,
    this.itemTypeId,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      stockPrice: json['stock_price'],
      barcode: json['barcode'],
      description: json['description'],
      tax: json['tax'],
      mrp: json['mrp'],
      hsn: json['hsn'],
      productCategoryId: json['product_category_id'],
      itemTypeId: json['item_type_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }
}

// class OrderPayment {
//   int? id;
//   int? orderId;
//   String? paymentType;
//   num? paidAmount;
//   String? createdAt;
//   String? updatedAt;
//   int? status;
//   dynamic? paymentTime;
//
//   OrderPayment({
//     this.id,
//     this.orderId,
//     this.paymentType,
//     this.paidAmount,
//     this.createdAt,
//     this.updatedAt,
//     this.status,
//     this.paymentTime,
//   });
//
//   factory OrderPayment.fromJson(Map<String, dynamic> json) {
//     return OrderPayment(
//       id: json['id'],
//       orderId: json['order_id'],
//       paymentType: json['payment_type'],
//       paidAmount: json['paid_amount'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       status: json['status'],
//       paymentTime: json['payment_time'],
//     );
//   }
// }

class OrderPayment {
  int? id;
  int? orderId;
  String? paymentType;
  num? paidAmount;
  String? createdAt;
  String? updatedAt;
  int? status;
  dynamic paymentTime;

  OrderPayment({
    this.id,
    this.orderId,
    this.paymentType,
    this.paidAmount,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.paymentTime,
  });

  factory OrderPayment.fromJson(Map<String, dynamic> json) {
    return OrderPayment(
      id: json['id'],
      orderId: json['order_id'],
      paymentType: json['payment_type'],
      paidAmount: json['paid_amount'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      paymentTime: json['payment_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'payment_type': paymentType,
      'paid_amount': paidAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'payment_time': paymentTime,
    };
  }
}
