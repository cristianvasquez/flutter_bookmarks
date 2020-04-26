import 'dart:typed_data';

import 'package:CardFLows/model/images.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RandomSplashPhoto extends StatelessWidget {
  final int index;
  final String queryString;
  SplashImage splashImage;
  Map<String, Uri> visitedUrls;

  RandomSplashPhoto({Key key, this.index, this.visitedUrls, this.queryString})
      : super(key: key);

  Future<Response> fetchPhoto() async {
    String url =
        'https://source.unsplash.com/random/320x280/?$queryString/$index';
    return Dio().get(url, options: Options(responseType: ResponseType.bytes));
  }

  @override
  Widget build(BuildContext context) {
    if (visitedUrls.containsKey(index)) {
      return FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: visitedUrls[index].toString(),
      );
    } else {
      return FutureBuilder<Response>(
        future: fetchPhoto(),
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            Response response = snapshot.data;
            visitedUrls['${index}_$queryString'] = response.realUri;
            splashImage = SplashImage(response.realUri);
            children = <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: <Widget>[
                    Image(
                      image: MemoryImage(
                        Uint8List.fromList(response.data),
                      ),
                    ),
                  ],
                ),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              const SizedBox(
                child: const CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: const EdgeInsets.only(top: 16),
                child: const Text('Loading random photo...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      );
    }
  }
}
