import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class ImageBuilder extends StatefulWidget {
  Future<String> Function() getImage;

  ImageBuilder({super.key , required this.getImage});

  @override
  State<ImageBuilder> createState() => _ImageBuilderState();
}

class _ImageBuilderState extends State<ImageBuilder> {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder<String>(
      future: widget.getImage(),
      builder: (context , snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return CachedNetworkImage(
              imageUrl: snapshot.data!,
              placeholder: (context , url){
                return CardLoading(height: double.infinity);
              },
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover
          );
        } else {
          return Text('No Image URL');
        }
      }
    );
  }
}
