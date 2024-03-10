import 'package:fanxange/Model/PlayerModel.dart';
import 'package:fanxange/appwrite/auth_api.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlayerListTile extends StatelessWidget {
  const PlayerListTile({
    Key? key,
    required this.playersdata,
  }) : super(key: key);

  final Player? playersdata;

  @override
  Widget build(BuildContext context) {
    final authApi = context.read<AuthAPI>();
    final databaseApi = context.read<DatabaseAPI>();

    return Card(
      color: Colors.white,
      elevation: 2,
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
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Bought 0",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFE9879),
                  fontSize: 14,
                ),
              ),
              Text(
                "Sold 0",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF21899C),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  databaseApi.setOrderType("buy");
                  databaseApi.setPlayerPrice(
                      int.tryParse(playersdata?.buyRate ?? '0') ?? 0);
                  databaseApi.setMatchId(databaseApi.matchdata.matchkey);
                  databaseApi.setPlayerId(playersdata?.playerkey.toString());
                  databaseApi.setTeamId(playersdata?.teamname);
                  databaseApi.setUserId(authApi.userid);
                  databaseApi.clearOrder();
                  _showPlayerDetailsModal(context, "buy");
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                        254, 152, 121, 0.8), // Adjusted opacity for Buy button
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Buy: ₹${playersdata?.buyRate.toString() ?? ''}",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  databaseApi.setOrderType("sell");
                  databaseApi.setPlayerPrice(
                      int.tryParse(playersdata?.sellRate ?? '0') ?? 0);
                  databaseApi.setUserId(authApi.userid);
                  databaseApi.setMatchId(databaseApi.matchdata.matchkey);
                  databaseApi.setPlayerId(playersdata?.playerkey.toString());
                  databaseApi.setTeamId(playersdata?.teamname);
                  databaseApi.clearOrder();
                  _showPlayerDetailsModal(context, "sell");
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors
                        .transparent, // Transparent background for Sell button
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: const Color(
                            0xFF21899C)), // Optional border for visibility
                  ),
                  child: Text(
                    "Sell: ₹${playersdata?.sellRate.toString() ?? ''}",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF21899C),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showPlayerDetailsModal(BuildContext context, String type) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final databaseApi = context.watch<DatabaseAPI>();
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: type == 'sell'
                        ? const Color(0xFF21899C)
                        : const Color(0xFFFE9879),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      type == 'sell' ? "Sell Player" : "Buy Player",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  backgroundImage: NetworkImage(playersdata?.image ?? ''),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 70,
                  height: 25,
                  decoration: BoxDecoration(
                    color: type == 'sell'
                        ? const Color(0xFF21899C)
                        : const Color(0xFFFE9879),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      playersdata?.teamname ?? 'Team Name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  playersdata?.name ?? 'Player Name',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  playersdata?.role ?? 'Player Role',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10),
                // Initial price and number of shares
                _buildDetailColumn(
                  'Initial Price',
                  '₹ ${type == 'sell' ? playersdata?.sellRate : playersdata?.buyRate}',
                ),
                const ShareCounter(), // Updated to const

                _buildDetailColumn(
                  'Platform fees (10%)',
                  '₹ ${databaseApi.fees}',
                ),
                _buildDetailColumn(
                  'Total Amount',
                  '₹ ${databaseApi.totalAmount}',
                  // '₹ ',
                ),
                const SizedBox(height: 16),
                // Buy and Sell buttons at the bottom
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the action (buy or sell)
                        // You can add logic here to execute the order
                        databaseApi.createOrder();

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: type == 'sell'
                            ? const Color(0xFF21899C)
                            : const Color(0xFFFE9879),
                      ),
                      child: const Text(
                        "Execute Order",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Divider(),
        ],
      ),
    );
  }
}

class ShareCounter extends StatelessWidget {
  const ShareCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No. of Shares',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (databaseAPI.shares > 1) {
                          databaseAPI.updateQty(databaseAPI.shares - 1);
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: Text(
                          databaseAPI.shares.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (databaseAPI.shares < 101) {
                          databaseAPI.updateQty(databaseAPI.shares + 1);
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}
