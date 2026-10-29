import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_erp/ui/color/appColor.dart';

class CustomerCard extends StatelessWidget {
  final String companyName;
  final String number;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  const CustomerCard({
    super.key,
    required this.companyName,
    required this.number,
    required this.onPressed,
    required this.onLongPressed,
  });
  String getDp(String inputString) {
    // Split the input string by spaces
    if (inputString == '') {
      return 'NA';
    }
    List<String> words = inputString!.split(' ');

    // Check if there is at least one word with more than one character
    if (words.length > 1 && words[1].isNotEmpty) {
      // Get the first character of the second word (first letter after a space)
      String firstLetterAfterSpace = words[1][0];
      return words[0][0] + firstLetterAfterSpace;
    } else {
      return words[0][0];
      print("No space or word after space found");
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Random random = Random();
    // print('comapany name = ${companyName}');
    return InkWell(
      splashColor: Colors.black.withOpacity(0.2),
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: Container(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.6,
                    color: Color.fromARGB(255, 213, 213, 213),
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 211, 211, 211),
                        radius: 22,
                        child: Text(
                          // companyName==null?'N':
                          getDp(companyName),

                          style: TextStyle(
                              color: AppColors.main,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName ?? 'No Name',
                        // '',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        number,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 68, 68, 68),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "No dues",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
