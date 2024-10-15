import 'package:flutter/material.dart';

import 'package:sheduling_app/teacher/core/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

class TextResponseShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: lightBlueColor,
      highlightColor: blueWhiteColor,
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: ListView.builder(
          reverse: true,
          // padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            );
          },
        ),
      ),
    );
  }
}
