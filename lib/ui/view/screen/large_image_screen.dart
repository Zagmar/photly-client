import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/post_view_model.dart';

bool _onPressed = false;

class LargeImageScreen extends StatelessWidget {
  LargeImageScreen({Key? key}) : super(key: key);
  late PostViewModel _postViewModel;

  @override
  Widget build(BuildContext context) {
    _postViewModel = Provider.of<PostViewModel>(context);
    return GestureDetector(
      onVerticalDragEnd: (detail){
        if(detail.primaryVelocity! > 5){
          Navigator.pop(context);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF000000),
            leading: IconButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios)
            ),
            /*
            actions: <Widget>[
              IconButton(
                  onPressed: () async {
                    print("다운로드");
                    FocusScope.of(context).unfocus();
                    await _postViewModel.downloadImage();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            _postViewModel.downloadResultMessage
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.save_alt_outlined)
              ),
            ],

             */
            elevation: 0,
          ),
          body: Container(
            color: Color(0xFF000000),
            alignment: Alignment.center,
            child: CachedNetworkImage(
              imageUrl: _postViewModel.tempImageUrl,
              fit: BoxFit.contain,
            ),
          )
      ),
    );
  }
}
