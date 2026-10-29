import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_erp/features/Quotation/controller/thermalPrintController.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../../ui/color/appColor.dart';

class ThermalPrintDialog extends StatefulWidget {
  @override
  _ThermalPrintDialogState createState() => _ThermalPrintDialogState();
}

class _ThermalPrintDialogState extends State<ThermalPrintDialog> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  String lineSpace = '                                              ';
  String dottedLine = '-----------------------------------------------';

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print('bluetooth device state: connected');
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print('bluetooth device state: disconnected');
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print('bluetooth device state: disconnect requested');
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print('bluetooth device state: bluetooth turning off');
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print('bluetooth device state: bluetooth off');
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print('bluetooth device state: bluetooth on');
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print('bluetooth device state: bluetooth turning on');
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print('bluetooth device state: error');
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  void dispose() {
    bluetooth.disconnect();
    super.dispose();
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(
        const DropdownMenuItem(
          child: Text('Bluetooth Not Connected'),
        ),
      );
    } else {
      for (var device in _devices) {
        if (device.name != null) {
          items.add(
            DropdownMenuItem(
              value: device,
              child: Text(device.name ?? ''),
            ),
          );
        }
      }
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: ShapeBorder.lerp(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        1,
      ),
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton<BluetoothDevice>(
                  icon: Container(), // Remove the default icon
                  hint: const Text("Tap to select device"),
                  items: _getDeviceItems(),
                  onChanged: (BluetoothDevice? value) {
                    setState(() => _device = value);
                    if (_device != null) {
                      bluetooth.isConnected.then((isConnected) {
                        if (isConnected != true) {
                          bluetooth.connect(_device!).catchError((error) {
                            setState(() {
                              print('_connected = false');
                              _connected = false;
                            });
                          });
                          setState(() {
                            print('_connected = true');
                            _connected = true;
                          });
                        }
                      });
                    }
                  },
                  value: _device,
                  underline: Container(), // Remove the underline
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _connected? _device!=null? AppColors.mainblue : Colors.grey : Colors.grey,
                  ),
                  onPressed: () async{
                    if(_connected){
                      if(_device!=null){
                        bluetooth.isConnected.then((connected){
                          print("Bluetooth is Connected");
                          if(connected==true){
                            bluetooth
                              ..printCustom('Sales Invoice', 1, 1)
                              ..printCustom('Mobile ERP App', 1, 1);
                          }
                        });
                        print("Success!");
                        await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Data added successfully',
                            onConfirmBtnTap: () => {
                              Navigator.of(context).pop(),
                              Navigator.of(context).pop(),
                            });
                      }
                    }
                  },
                  child: Text('Print'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}