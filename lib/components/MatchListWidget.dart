import 'package:flutter/material.dart';
import 'package:fanxange/appwrite/database_api.dart';
import 'package:fanxange/pages/Search.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MatchListWidget extends StatelessWidget {
  MatchListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final databaseAPI = context.watch<DatabaseAPI>();
    return Skeletonizer(
      enabled: databaseAPI.isMatchLoading,
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: databaseAPI.matchlist?.documents.length ?? 0,
          itemBuilder: (context, index) {
            var ipodata = databaseAPI.matchlist?.documents[index];
            return MatchListTile(ipodata: ipodata);
          }),
    );
  }
}
