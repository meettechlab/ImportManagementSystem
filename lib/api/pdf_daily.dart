import 'dart:io';
import 'package:importmanagementsoftware/api/pdf_api.dart';
import 'package:importmanagementsoftware/model/invoiceCompany.dart';
import 'package:importmanagementsoftware/model/invoiceCrusherSale.dart';
import 'package:importmanagementsoftware/model/invoiceDaily.dart';
import 'package:importmanagementsoftware/model/invoiceEmployee.dart';
import 'package:importmanagementsoftware/model/invoiceStonePurchase.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfDaily {
  static Future<File> generate(InvoiceDaily invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a3,
      build: (context) => [
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(
        "daily" + DateFormat('dd-MMM-yyyy-jms').format(DateTime.now()) + ".pdf",
        pdf);
  }

  static Widget buildTitle(InvoiceDaily invoice) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Date : ' + DateFormat('dd-MMM-yyyy').format(DateTime.now()),
            style: TextStyle(
              fontSize: 10,
            )),
        SizedBox(height: 2 * PdfPageFormat.cm),
        Text('Type : ' + invoice.type,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
      ]);

  static Widget buildInvoice(InvoiceDaily invoice) {
    final headers = [
      'Date',
      'Transport',
      'Unload',
      'Depo Rent',
      'Koipot',
      'Stone Crafting',
      'Diesel',
      'Gris',
      'Mobil',
      'Extra',
      'Total',
      'Remarks'
    ];

    final data = invoice.items.map((item) {
      return [
        item.date,
        item.transport,
        item.unload,
        item.depo,
        item.koipot,
        item.stone,
        item.dissel,
        item.griss,
        item.mobil,
        item.extra,
        item.total,
        item.remarks
      ];
    }).toList();
    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
        8: Alignment.centerRight,
        9: Alignment.centerRight,
        10: Alignment.centerRight,
        11: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(InvoiceDaily invoice) {
    return Container(
        alignment: Alignment.centerRight,
        child: Row(children: [
          Spacer(flex: 6),
          Expanded(
              flex: 4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                        title: "Total Amount",
                        value: invoice.totalCost,
                        unite: true)
                  ]))
        ]));
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
        width: width,
        child: Row(children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ]));
  }

  static Widget buildFooter() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Divider(),
        SizedBox(height: 2 * PdfPageFormat.mm),
        buildFooterText(
            title: 'Organisation :',
            value: 'M/S Priya Enterprise & B.N. Traders'),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Contact :', value: '+8801711-362096'),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Address :', value: 'Laldighirpar, Sylhet'),
        SizedBox(height: 1 * PdfPageFormat.mm),
        buildFooterText(title: 'Developed By :', value: 'MeetTech Lab '),
      ]);

  static buildFooterText({required String title, required String value}) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: style),
          SizedBox(width: 2 * PdfPageFormat.mm),
          Text(value),
        ]);
  }
}
