import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nityaassociation/model/bytes_model.dart';
import 'package:nityaassociation/utils/constants.dart';
import 'package:nityaassociation/utils/image_helper.dart';

class ByteItem extends StatelessWidget {
  final BytesModel byte;

  ByteItem(this.byte);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Container(
          width: 40,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            BULLETIN,
            color: kPrimaryColor,
          ),
        ),
        subtitle: Text(
          byte.createdAt,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        title: Text(
          byte.news,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
