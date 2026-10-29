import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/Quotation/controller/quotation_controller.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class pdfview extends StatefulWidget {
  const pdfview({super.key});

  @override
  State<pdfview> createState() => _pdfviewState();
}

class _pdfviewState extends State<pdfview> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  QuotationController qc = Get.find<QuotationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reciept'), actions: [
        IconButton(onPressed: () {
          _launchInBrowser(Uri.parse(qc.currentorderpdf.value));
        }, icon: Icon(Icons.download)),
        IconButton(
            onPressed: () {
              // Share.share(qc.currentorderpdf.value);
            },
            icon: Icon(Icons.share)),
      ]),
      body: Container(
        child: SfPdfViewer.network(
          qc.currentorderpdf.value,
          key: _pdfViewerKey,
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}
