import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/ui/Buttons/CustomButton.dart';

import '../../../../ui/color/appColor.dart';

class AddAddressWidget extends StatefulWidget {
  final bool isShipping;
  const AddAddressWidget({Key? key, this.isShipping = false}) : super(key: key);

  @override
  State<AddAddressWidget> createState() => _AddAddressWidgetState();
}

class _AddAddressWidgetState extends State<AddAddressWidget> {
  final CustomerController cc = Get.find<CustomerController>();
  
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _address1Controller.text = widget.isShipping ? cc.address_1_shipping.value : cc.address_1_billing.value;
    _address2Controller.text = widget.isShipping ? cc.address_2_shipping.value : cc.address_2_billing.value;
    _pincodeController.text = widget.isShipping ? cc.pincode_shipping.value : cc.pincode_billing.value;
    _cityController.text = widget.isShipping ? cc.city_shipping.value : cc.city_billing.value;
    _stateController.text = widget.isShipping ? cc.state_shipping.value : cc.state_billing.value;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 0.52,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  height: 3,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter Address',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _address1Controller,
                label: 'Address Line 1',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _address2Controller,
                label: 'Address Line 2',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _pincodeController,
                label: 'Pincode',
                suffixIcon: Container(
                  width: 100,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    color: AppColors.mainblue,
                  ),
                  child: const Text(
                    "Fetch Details",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _cityController,
                label: 'City',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _stateController,
                label: 'State *',
              ),
              Container(
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: CustomButton(
                      height: 53,
                      title: 'Save',
                      buttonText: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      backgroundColor: AppColors.mainblue,
                      borderRadius: 15,
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
      child: TextField(
        controller: controller,
        onChanged: (val) {
          if (widget.isShipping) {
            if (controller == _address1Controller) {
              cc.address_1_shipping.value = val;
            } else if (controller == _address2Controller) {
              cc.address_2_shipping.value = val;
            } else if (controller == _pincodeController) {
              cc.pincode_shipping.value = val;
            } else if (controller == _cityController) {
              cc.city_shipping.value = val;
            } else if (controller == _stateController) {
              cc.state_shipping.value = val;
            }
          } else {
            if (controller == _address1Controller) {
              cc.address_1_billing.value = val;
            } else if (controller == _address2Controller) {
              cc.address_2_billing.value = val;
            } else if (controller == _pincodeController) {
              cc.pincode_billing.value = val;
            } else if (controller == _cityController) {
              cc.city_billing.value = val;
            } else if (controller == _stateController) {
              cc.state_billing.value = val;
            }
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          label: Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          alignLabelWithHint: true,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400,
            fontSize: 15,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
