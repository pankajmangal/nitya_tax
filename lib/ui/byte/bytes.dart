import 'package:flutter/material.dart';
import 'package:nityaassociation/model/bytes_model.dart';
import 'package:nityaassociation/ui/byte/bloc/bytes_bloc.dart';
import 'package:nityaassociation/ui/byte/byte_item.dart';
import 'package:nityaassociation/ui/common/error_page.dart';
import 'package:nityaassociation/ui/common/loading_page.dart';
import 'package:nityaassociation/utils/app_utils.dart';

class BytesPage extends StatefulWidget {
  @override
  _BytesPageState createState() => _BytesPageState();
}

class _BytesPageState extends State<BytesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<ByteResponse>(
      stream: bytesBloc.bytes,
      builder: (context, AsyncSnapshot<ByteResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return ErrorPage(
              errorMsg: snapshot.data.error,
              retry: fetchBytes,
            );
          }
          return ListView.separated(
              itemBuilder: (_, index) {
                return ByteItem(snapshot.data.bytes[index]);
              },
              separatorBuilder: (_, __) => SizedBox(
                    height: 2,
                  ),
              itemCount: snapshot.data.bytes.length);
        } else if (snapshot.hasError) {
          return ErrorPage(
            errorMsg: snapshot.error,
            retry: fetchBytes,
          );
        } else {
          return LoadingPage("Fetching Bytes");
        }
      },
    ));
  }

  Future<void> fetchBytes() async {
    await bytesBloc.fetchBytes(AppUtils.currentUser.accessToken);
    return;
  }
}
