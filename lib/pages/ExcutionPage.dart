import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fanxange/components/MyAppBar.dart';

class ExecutionPage extends StatelessWidget {
  static String routeName = "/execute";

  const ExecutionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(isActions: false),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myText("Nifty 50", Color.fromARGB(255, 90, 119, 125), 15.0,
                      FontWeight.bold),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "₹24,456.00",
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OrderExecutionRow(),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Balance: 1,71,545.00",
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "Required: 1,71,545.00",
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            Divider(
              color: Color.fromARGB(255, 90, 119, 125),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButtons(),
    );
  }

  Text myText(text, color, size, weight) {
    return Text(
      text,
      style:
          GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color),
    );
  }
}

class OrderExecutionRow extends StatefulWidget {
  @override
  _OrderExecutionRowState createState() => _OrderExecutionRowState();
}

class _OrderExecutionRowState extends State<OrderExecutionRow> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Qty',
                hintText: 'Enter quantity',
                filled: true,
                fillColor: Colors.grey[200], // Greyish background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: TextField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(fontSize: 16, color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Price',
                hintText: 'Enter price',
                filled: true,
                fillColor: Colors.grey[200], // Greyish background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 16),
      child: Container(
        height: 50,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, ExecutionPage.routeName),
                child: Container(
                  width: 50,
                  child: Center(
                    child: Text(
                      "EXECUTE ORDER",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF2ABF9C),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
