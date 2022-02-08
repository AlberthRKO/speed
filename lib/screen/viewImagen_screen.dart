import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImagen extends StatelessWidget {
  const ViewImagen({
    Key key,
    @required this.imagen,
  }) : super(key: key);

  final ImageProvider<Object> imagen;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista de la imagen'),
      ),
      body: Center(
        child: Container(
          child: PhotoView(
            imageProvider: imagen,
          ),
        ),
      ),
    );
  }
}
