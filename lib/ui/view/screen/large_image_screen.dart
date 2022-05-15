import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/post_view_model.dart';

class LargeImageScreen extends StatelessWidget {
  LargeImageScreen({Key? key}) : super(key: key);
  late PostViewModel _postViewModel;

  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<PostViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF000000),
          leading: Container(),
          actions: <Widget>[
            IconButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.clear)
            )
          ],
          elevation: 0,
        ),
        body: Container(
          color: Color(0xFF000000),
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl: _postViewModel.tempImageUrl,
            fit: BoxFit.fitWidth,
          ),
        )
    );
  }
}
