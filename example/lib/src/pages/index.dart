import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './call.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  final _channelController = TextEditingController();
  final _userIdController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  @override
  void initState() {
    super.initState();
    _channelController.text = "room1";
    _userIdController.text = "user1";
  }

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Huawei RTC Flutter QuickStart'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText: _validateError ? 'room name is mandatory' : null,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  hintText: 'room name',
                ),
              )),
              Expanded(
                  child: TextField(
                controller: _userIdController,
                decoration: InputDecoration(
                  errorText: _validateError ? 'UserId is mandatory' : null,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  hintText: 'UserId',
                ),
              )),
              buildRole(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: onJoin,
                        child: Text('加入'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });

    if (_channelController.text.isNotEmpty &&
        _userIdController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      // push video page with given channel name

//      log("${_channelController.text}");
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            roomId: _channelController.text,
            userId: _userIdController.text,
            roleType: _groupValue,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }

  var _groupValue = RoleType.ROLE_TYPE_JOINER;

  buildRole() {
    return Row(
      children: <Widget>[
        _buildRadio(RoleType.ROLE_TYPE_JOINER),
        Text("joiner"),
        _buildRadio(RoleType.ROLE_TYPE_PUBLISHER),
        Text("publisher"),
        _buildRadio(RoleType.ROLE_TYPE_PLAYER),
        Text("player"),
      ],
    );
  }

  _buildRadio(RoleType roleType) {
    return Radio(
        value: roleType,
        groupValue: _groupValue,
        onChanged: (value) {
          setState(() {
            _groupValue = value;
          });
        });
  }
}
