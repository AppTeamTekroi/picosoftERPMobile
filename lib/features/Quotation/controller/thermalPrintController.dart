
////*************** This code is not working *****************////


// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
//
// class ThermalPrintController extends GetxController {
//   var loading = false.obs;
//   BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
//   RxList<BluetoothDevice> devices = <BluetoothDevice>[].obs;
//
//   RxList<DropdownMenuItem<BluetoothDevice>> items = <DropdownMenuItem<BluetoothDevice>>[].obs;
//
//   Rx<BluetoothDevice>? device;
//   RxBool connected = false.obs;
//   String lineSpace = '                                              ';
//   String dottedLine = '-----------------------------------------------';
//
//   @override
//   void onInit() {
//     super.onInit();
//     initPlatformState().then((value) {
//       print('Bluetooth initialized');
//     }).onError((error, stackTrace) {
//       print('Bluetooth initialization error: $error');
//     });
//   }
//
//   Future<void> initPlatformState() async {
//     loading.value = true;
//     bool? isConnected = await bluetooth.isConnected;
//     try {
//       devices.value = await bluetooth.getBondedDevices();
//     } on PlatformException {}
//
//     bluetooth.onStateChanged().listen((state) {
//       switch (state) {
//         case BlueThermalPrinter.CONNECTED:
//           connected.value = true;
//           getDeviceItems();
//           print('bluetooth device state: connected');
//           break;
//         case BlueThermalPrinter.DISCONNECTED:
//           connected.value = false;
//           getDeviceItems();
//           print('bluetooth device state: disconnected');
//           break;
//         case BlueThermalPrinter.DISCONNECT_REQUESTED:
//           connected.value = false;
//           getDeviceItems();
//           print('bluetooth device state: disconnect requested');
//           break;
//         case BlueThermalPrinter.STATE_TURNING_OFF:
//           connected.value = false;
//           getDeviceItems();
//           print('bluetooth device state: bluetooth turning off');
//           break;
//         case BlueThermalPrinter.STATE_OFF:
//           connected.value = false;
//           getDeviceItems();
//           print('bluetooth device state: bluetooth off');
//           break;
//         case BlueThermalPrinter.STATE_ON:
//           connected.value = false;
//           getDeviceItems();
//           print('bluetooth device state: bluetooth on');
//           break;
//         case BlueThermalPrinter.STATE_TURNING_ON:
//           connected.value = false;
//           getDeviceItems();
//           print('bluetooth device state: bluetooth turning on');
//           break;
//         case BlueThermalPrinter.ERROR:
//           connected.value = false;
//           getDeviceItems();
//           print('bluetooth device state: error');
//           break;
//         default:
//           getDeviceItems();
//           print(state);
//           break;
//       }
//       update(); // Notify listeners of state changes
//     });
//
//     if (isConnected == true) {
//       connected.value = true;
//     }
//     loading.value = false;
//   }
//
//   List<DropdownMenuItem<BluetoothDevice>> getDeviceItems() {
//     items.clear();
//     if (devices.isEmpty && connected.value==false) {
//       print('No devices found');
//       items.add(
//         const DropdownMenuItem(
//           child: Text('Bluetooth Not Connected'),
//         ),
//       );
//     } else {
//       print('Devices found');
//       for (var device in devices) {
//         if (device.name != null) {
//           print(device.address);
//           items.add(
//             DropdownMenuItem(
//               value: device,
//               child: Text(device.name ?? ''),
//             ),
//           );
//         }
//       }
//     }
//     print(items.length);
//     return items;
//   }
//
//   @override
//   void onClose() {
//     bluetooth.onStateChanged().listen((state) {}).cancel();
//     super.onClose();
//   }
// }
