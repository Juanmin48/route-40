import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite extends StatefulWidget {
  final bool fav;
  final User user;
  const Favorite({Key key, @required this.fav, @required this.user})
      : super(key: key);
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool _isFavorited;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isFavorited = widget.fav;
    });
  }

  void _toggleFavorite(user) {
    //Agregar aqui codigo para agregar o eliminar ruta de los favoritos de @user dependiendo del booleano @_isFavorited
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
        var data;
        FirebaseFirestore.instance.doc("users/${widget.user.uid}").update({
          //Write just value which you need to update, like a:
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: IconButton(
        icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
        color: Color.fromRGBO(255, 154, 81, 1),
        iconSize: 30,
        onPressed: () => _toggleFavorite(widget.user),
      ),
    );
  }
  // ···
}
