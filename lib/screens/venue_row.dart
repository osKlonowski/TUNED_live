import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VenueRow extends StatefulWidget {
  final QuerySnapshot snapshot;

  const VenueRow({Key key, @required this.snapshot}): super(key: key);

  @override
  _VenueState createState() => _VenueState(snapshot);
}

class _VenueState extends State<VenueRow> {
  QuerySnapshot snapshot;
  _VenueState(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}