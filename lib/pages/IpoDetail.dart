// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, must_be_immutable, unused_local_variable

import 'package:appwrite/models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/components/MyAppBar.dart';
import 'package:fanxange/pages/ExcutionPage.dart';
import 'package:provider/provider.dart';

class IPODetailPage extends StatelessWidget {
  static String routeName = "/ipodetail";

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  // Initialize min and max values for X and Y
  double minX = double.infinity;
  double maxX = -double.infinity;
  double minY = double.infinity;
  double maxY = -double.infinity;

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    // Initialize factor for scaling timestamp
    final double timestampFactor = 1 / 3600.0;

    List<double> doubleDates = databaseAPI.ipographdata
        .map((entry) =>
            DateFormat('dd-MMM-yyyy hh:mm a')
                .parse(entry.data['updated_time'])
                .millisecondsSinceEpoch
                .toDouble() *
            timestampFactor)
        .toList();

    for (var entry in databaseAPI.ipographdata) {
      // Extract X and Y values
      double xValue = DateFormat('dd-MMM-yyyy hh:mm a')
              .parse(entry.data['updated_time'])
              .millisecondsSinceEpoch
              .toDouble() *
          timestampFactor;
      double yValue = int.parse(entry.data['price']).toDouble();

      // Update min and max values for X
      minX = xValue < minX ? xValue : minX;
      maxX = xValue > maxX ? xValue : maxX;

      // Update min and max values for Y
      minY = yValue < minY ? yValue : minY;
      maxY = yValue > maxY ? yValue : maxY;
    }

    // Separate lists for dates and prices
    List<double> prices = [];
    List<String> dates = [];

    for (var entry in databaseAPI.ipographdata) {
      prices.add(int.parse(entry.data['price']).toDouble());
      dates.add(entry.data['updated_time']);
    }
    return Scaffold(
      appBar: MyAppBar(
        isActions: false,
      ),
      body: databaseAPI.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  myText(databaseAPI.ipodata?['name'] ?? '',
                      Color.fromARGB(255, 90, 119, 125), 15.0, FontWeight.bold),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "₹${databaseAPI.ipodata?['premium']}",
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomLineChart(
                      minX: minX,
                      maxX: maxX + 999,
                      minY: minY,
                      maxY: maxY,
                      doubleDates: doubleDates,
                      data: databaseAPI.ipographdata,
                      gradientColors: gradientColors),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Performance",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomPaint(
                    painter: MovableArrowLinePainter(),
                    child: Container(
                      height: 60.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Low ",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "₹${minY}",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "High",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "₹${maxY}",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ), // Adjust the height of the line
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Market Orders",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(child: MarketOrdersBook()),
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle();

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        value.toInt() * 3600); // Multiply by 60
    String text = DateFormat('M').format(dateTime);

    return FittedBox(
      child: Text(text, style: style, textAlign: TextAlign.center),
      fit: BoxFit.fitWidth,
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
                  decoration: BoxDecoration(
                    color: Color(0xFFED2222),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "SELL",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, ExecutionPage.routeName),
                child: Container(
                  width: 50,
                  child: Center(
                    child: Text(
                      "BUY",
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

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({
    super.key,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.doubleDates,
    required this.data,
    required this.gradientColors,
  });

  final double minX;
  final double maxX;
  final double minY;
  final double maxY;
  final List<double> doubleDates;
  final List<Document> data;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: false,
            )),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                doubleDates.length,
                (index) {
                  return FlSpot(doubleDates[index],
                      int.parse(data[index].data['price']).toDouble());
                },
              ),
              isCurved: false,
              gradient: LinearGradient(colors: gradientColors),
              barWidth: 1,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                    colors:
                        gradientColors.map((e) => e.withOpacity(0.2)).toList()),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MovableArrowLinePainter extends CustomPainter {
  double arrowPosition =
      0.02; // Initial position of the arrow (between 0.0 and 1.0)

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xFF2ABF9C) // Set the line color
      ..strokeWidth = 3.0;

    final double arrowSize = 10.0;
    final double lineLength = size.width;

    // Draw the line
    canvas.drawLine(
      Offset(0, size.height),
      Offset(lineLength, size.height),
      paint,
    );

    // Calculate the arrow position along the line
    final double arrowX = arrowPosition * lineLength;

    // Draw the arrow pointing at the bottom
    Path path = Path()
      ..moveTo(arrowX, size.height)
      ..lineTo(arrowX - arrowSize, size.height + arrowSize)
      ..lineTo(arrowX + arrowSize, size.height + arrowSize)
      ..close();

    canvas.drawPath(path, paint);
  }

  void updateArrowPosition(double width, Size size) {
    // Update arrow position based on the width
    arrowPosition = width / size.width;
    if (arrowPosition < 0.0) {
      arrowPosition = 0.0;
    } else if (arrowPosition > 1.0) {
      arrowPosition = 1.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BidOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example bid orders
    List<Order> bidOrders = [
      Order(price: 100.0, quantity: 5),
      Order(price: 99.5, quantity: 10),
      Order(price: 99.0, quantity: 8),
      // Add more bid orders as needed
    ];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTable(
            columns: [
              DataColumn(
                  label:
                      Text('Bid Price', style: TextStyle(color: Colors.grey))),
              DataColumn(
                  label: Text('Qty', style: TextStyle(color: Colors.grey))),
            ],
            rows: bidOrders.map((order) {
              return DataRow(cells: [
                DataCell(Text(order.price.toStringAsFixed(2))),
                DataCell(Text(order.quantity.toString(),
                    style: TextStyle(color: Colors.green[600]))),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class AskOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example ask orders
    List<Order> askOrders = [
      Order(price: 101.0, quantity: 7),
      Order(price: 101.5, quantity: 12),
      Order(price: 102.0, quantity: 9),
      // Add more ask orders as needed
    ];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTable(
            columns: [
              DataColumn(
                label: Text('Ask Price', style: TextStyle(color: Colors.grey)),
              ),
              DataColumn(
                  label: Text('Qty', style: TextStyle(color: Colors.grey))),
            ],
            rows: askOrders.map((order) {
              return DataRow(cells: [
                DataCell(Text(order.price.toStringAsFixed(2))),
                DataCell(Text(order.quantity.toString(),
                    style: TextStyle(color: Colors.red))),
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class Order {
  final double price;
  final int quantity;

  Order({required this.price, required this.quantity});
}

class MarketOrdersBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BidOrders(),
          ),
          Container(
            height: 200, // Adjust the height of the divider container
            child: VerticalDivider(
              width: 1, // Adjust the width of the divider as needed
              color: Colors.grey, // Choose the color of the divider
            ),
          ),
          Expanded(
            child: AskOrders(),
          ),
        ],
      ),
    );
  }
}
