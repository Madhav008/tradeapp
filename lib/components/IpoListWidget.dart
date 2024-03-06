import 'package:flutter/material.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/Search.dart';
import 'package:provider/provider.dart';

class IPOListWidget extends StatelessWidget {
  IPOListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: databaseAPI.ipolist?.documents.length ?? 0,
        itemBuilder: (context, index) {
          if (databaseAPI.isLoading) {
            // Loading indicator when data is being fetched
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var ipodata = databaseAPI.ipolist?.documents[index].data;
            return IPOListTile(ipodata: ipodata);
          }
        });
  }
}
