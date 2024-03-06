import 'package:flutter/material.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/Search.dart';
import 'package:provider/provider.dart';

class MatchListWidget extends StatelessWidget {
  MatchListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: databaseAPI.matchlist?.documents.length ?? 0,
        itemBuilder: (context, index) {
          if (databaseAPI.isLoading) {
            // Loading indicator when data is being fetched
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var ipodata = databaseAPI.matchlist?.documents[index];
            return MatchListTile(ipodata: ipodata);
          }
        });
  }
}
