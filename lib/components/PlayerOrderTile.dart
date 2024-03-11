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

    int totalQuantity =
        playerOrders!.fold(0, (sum, order) => sum + order.shares);
    double totalPrice =
        playerOrders.fold(0, (sum, order) => sum + order.total_amount);

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10.0, left: 8, right: 8),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 255, 223, 201)),
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
                            color: const Color(0xFFFE9879),
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
                        )
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
                      // Row(
                      //   children: [
                      //     Text(
                      //       'Points:',
                      //       style: GoogleFonts.openSans(
                      //         fontSize: 14,
                      //         height: 1.2,
                      //       ),
                      //     ),
                      //     Text(
                      //       ' ${playersdata.}',
                      //       style: GoogleFonts.openSans(
                      //           fontSize: 14,
                      //           height: 1.2,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
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
                            'Toatal Amount: ',
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
  }
}
