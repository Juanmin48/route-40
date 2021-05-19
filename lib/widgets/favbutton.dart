import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite extends StatefulWidget {
  final bool fav;
  final User user;
  final dynamic route;
  const Favorite(
      {Key key, @required this.fav, @required this.user, @required this.route})
      : super(key: key);
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool _isFavorited;
  User _user;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  List _routes;
  String _id;

  @override
  void initState() {
    super.initState();
    setState(() {
      _user = widget.user;
      _isFavorited = widget.fav;
    });
    isFavorite(_user);
  }

  Future isFavorite(user) async {
    await _users
        .where("uid", isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      List routeUsers = snapshot.docs[0].data()['fav'];
      setState(() {
        _routes = routeUsers;
        _id = snapshot.docs[0].id;
      });
      for (var route in routeUsers) {
        if (widget.route['nameR'] == route['nameR']) {
          setState(() {
            _isFavorited = true;
          });
        }
      }
    });
  }

  Future _toggleFavorite(user) async {
    if (_isFavorited) {
      setState(() {
        _isFavorited = false;
      });
      _routes.removeWhere((item) => item['nameR'] == widget.route['nameR']);
      print(_routes);
    } else {
      setState(() {
        _isFavorited = true;
      });
      _routes.add(widget.route);
    }

    await _users.doc(_id).update({
      'fav': _routes,
    });
    // setState(() {
    //   if (_isFavorited) {
    //     _isFavorited = false;
    //   } else {
    //     _isFavorited = true;
    //     var data;
    //     FirebaseFirestore.instance.doc("users/${widget.user.uid}").update({
    //       //Write just value which you need to update, like a:
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: IconButton(
        icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
        color: Color.fromRGBO(255, 154, 81, 1),
        iconSize: 30,
        onPressed: () async {
          await _toggleFavorite(widget.user);
        },
      ),
    );
  }
  // ···
}
