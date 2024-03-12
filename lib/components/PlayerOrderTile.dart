import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fanxange/Model/PlayerModel.dart';
import 'package:fanxange/appwrite/database_api.dart';

class PlayerOrderTile extends StatelessWidget {
  const PlayerOrderTile({
    Key? key,
    required this.playersdata,
  }) : super(key: key);

  final Player? playersdata;

  @override
  Widget build(BuildContext context) {
    final databaseApi = context.watch<DatabaseAPI>();
    final playerOrders = databaseApi.userOrdersList
        ?.where((order) => order.playerid == playersdata?.playerkey)
        .toList();

    return Column(
      children: playerOrders?.map((order) {
            int totalQuantity = order.shares;
            double totalPrice = order.total_amount;
            String orderType = order.order_type
                .toUpperCase(); // Assuming orderType is a property in your Order model

            Color orderColor = orderType == 'BUY' ? Colors.green : Colors.red;

            return Padding(
              padding: const EdgeInsets.only(
                  top: 5, bottom: 10.0, left: 8, right: 8),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: orderColor.withOpacity(0.2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.network(
                            playersdata?.image ?? '',
                            height: 60,
                            width: 60,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playersdata?.name ?? '',
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  softWrap: true,
                                ),
                                Text(
                                  playersdata?.role ?? '',
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  width: 70,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: playersdata?.team == 'team1'
                                        ? const Color(0xFFFE9879)
                                        : Colors.black,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      playersdata?.teamname ?? '',
                                      style: GoogleFonts.openSans(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              width:
                                  10), // Add spacing between player info and qty/price
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    ' $orderType',
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      height: 1.2,
                                      fontWeight: FontWeight.bold,
                                      color: orderColor,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Qty:',
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      height: 1.2,
                                    ),
                                  ),
                                  Text(
                                    ' $totalQuantity',
                                    style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        height: 1.2,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Total Amount: ',
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      height: 1.2,
                                    ),
                                  ),
                                  Text(
                                    '₹ ${totalPrice.toStringAsFixed(2)}',
                                    style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        height: 1.2,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList() ??
          [],
    );
  }
}
