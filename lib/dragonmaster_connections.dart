// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dragonmaster/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dragonmaster/utils/signaling.dart';
import 'dart:core';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './utils/sputils.dart';

late String host;
late var hp;
late var sc;
late var mm;
late var hswo;
late var sm;
late var rc;
bool isMicOpened = false;
bool isSmallWindowOpened = false;

class DragonMasterConnectionScreen extends StatefulWidget {
  static String tag = 'DragonMasterHomeScreen';

  const DragonMasterConnectionScreen({super.key});

  @override
  State<DragonMasterConnectionScreen> createState() =>
      DragonMasterConnectionScreenState();
}

class DragonMasterConnectionScreenState
    extends State<DragonMasterConnectionScreen> {
  Signaling? _signaling;
  List<dynamic> _peers = [];
  String? _selfId;
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  Session? _session;

  bool _waitAccept = false;

  // ignore: unused_element
  DragonMasterConnectionScreenState();

  @override
  initState() {
    super.initState();
    initServer();
    (host != 'noDetected' && host != '')
        ? Fluttertoast.showToast(msg: '连接到服务器：$host，加载中...')
        : Fluttertoast.showToast(msg: '获取服务器失败，请先设置服务器！');
    initRenderers();
    _connect();
  }

  initServer() {
    host = (SpUtils.getString('server') != null)
        ? SpUtils.getString('server')!
        : 'noDetected';
    hp = _hangUp;
    sc = _switchCamera;
    mm = _muteMic;
    hswo = _handleSmallWindowOpen;
    sm = _syncMic;
    rc = _refreshConnection;
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    _signaling?.close();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  void _connect() async {
    _signaling ??= Signaling(host)..connect();
    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.connectionClosed:
        case SignalingState.connectionError:
        case SignalingState.connectionOpen:
          break;
      }
    };

    _signaling?.onCallStateChange = (Session session, CallState state) async {
      switch (state) {
        case CallState.callStateNew:
          setState(() {
            _session = session;
          });
          break;
        case CallState.callStateRinging:
        // 连接接收端执行部分
          _accept();
          setState(() {
            settingConnectedText = <String>[
              "刷新",
              "打开麦克风",
              "打开小窗",
              "切换摄像头",
              "断开连接",
            ];
            _inCalling = true;
            isMicOpened = false;
            sm(isMicOpened);
            isSmallWindowOpened = true;
            appSetState(() {
              deviceIsConnected = true;
            });
          });
          Fluttertoast.showToast(msg: '连接成功');
          Future.delayed(const Duration(milliseconds: 1000),(){
            sm(isMicOpened);
            rc();
          });
          break;
        case CallState.callStateBye:
          // 连接断开
          if (_waitAccept) {
            if (kDebugMode) {
              print('连接拒绝');
            }
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            _localRenderer.srcObject = null;
            _remoteRenderer.srcObject = null;
            _inCalling = false;
            appSetState(() {
              deviceIsConnected = false;
            });
            _session = null;
          });
          break;
        case CallState.callStateInvite:
          // 邀请连接部分
          _waitAccept = true;
          _showInvateDialog();
          break;
        case CallState.callStateConnected:
          // 连接发起端执行部分
          if (_waitAccept) {
            _waitAccept = false;
            Navigator.of(context).pop(false);
          }
          setState(() {
            settingConnectedText = <String>[
              "刷新",
              "打开麦克风",
              "关闭小窗",
              "切换摄像头",
              "断开连接",
            ];
            _inCalling = true;
            isMicOpened = false;
            isSmallWindowOpened = true;
            appSetState(() {
              deviceIsConnected = true;
            });
          });
          Fluttertoast.showToast(msg: '连接成功');
          Future.delayed(const Duration(milliseconds: 1000),(){
            sm(isMicOpened);
            rc();
          });
          break;
      }
    };

    _signaling?.onPeersUpdate = ((event) {
      setState(() {
        _selfId = event['self'];
        _peers = event['peers'];
      });
    });

    _signaling?.onLocalStream = ((stream) {
      _localRenderer.srcObject = stream;
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = stream;
    });

    _signaling?.onRemoveRemoteStream = ((_, stream) {
      _remoteRenderer.srcObject = null;
    });
  }

  Future<bool?> _showInvateDialog() {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          title: Text("连接中"),
          content: Text("等待连接建立"),
        );
      },
    );
  }

  _invitePeer(BuildContext context, String peerId, bool useScreen) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling?.invite(peerId, 'video', useScreen);
    }
  }

  _accept() {
    if (_session != null) {
      _signaling?.accept(_session!.sid);
    }
  }

  // _reject() {
  //   if (_session != null) {
  //     _signaling?.reject(_session!.sid);
  //   }
  // }

  _hangUp() {
    if (_session != null) {
      _signaling?.bye(_session!.sid);
    }
  }

  _switchCamera() {
    _signaling?.switchCamera();
  }

  _syncMic(bool p) {
    _signaling?.syncMic(p);
  }

  _refreshConnection() {
    setState(() {
      appSetState(() {});
    });
    Fluttertoast.showToast(msg: '刷新成功');
  }

  _muteMic() {
    _signaling?.muteMic();
    setState(() {
      appSetState(() {
        isMicOpened = !isMicOpened;
        if (isMicOpened) {
          settingConnectedText[1] = '关闭麦克风';
          Fluttertoast.showToast(msg: '麦克风已打开');
        } else {
          settingConnectedText[1] = '打开麦克风';
          Fluttertoast.showToast(msg: '麦克风已关闭');
        }
      });
    });
  }

  _handleSmallWindowOpen() {
    setState(() {
      appSetState(() {
        isSmallWindowOpened = !isSmallWindowOpened;
        if (isSmallWindowOpened) {
          settingConnectedText[2] = '关闭小窗';
          Fluttertoast.showToast(msg: '小窗已打开');
        } else {
          settingConnectedText[2] = '打开小窗';
          Fluttertoast.showToast(msg: '小窗已关闭');
        }
      });
    });
  }

  void showSimpleDialog(String peerId, BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              title: const Text('请选择连接方式'),
              children: [
                SimpleDialogOption(
                  child: const Text('屏幕共享'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _invitePeer(context, peerId, true);
                  },
                ),
                SimpleDialogOption(
                  child: const Text('视频传输'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _invitePeer(context, peerId, false);
                  },
                ),
              ],
            ));
  }

  _buildRow(context, peer) {
    var self = (peer['id'] == _selfId);
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(self
            ? '${peer['name']} [本机]'
            : peer['name']),
        trailing: SizedBox(
            width: 100.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(self ? null : Icons.sync,
                        color:
                            useLightMode ? materialYouBlack : materialYouWhite),
                    onPressed: self
                        ? null
                        : () => showSimpleDialog(peer['id'], context),
                    tooltip: self ? null : '连接',
                  )
                ])),
        subtitle: Text('ID:${peer['id']} - ${peer['user_agent']}'),
      ),
      const Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: _inCalling
            ? OrientationBuilder(builder: (context, orientation) {
                return SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Stack(children: <Widget>[
                    Positioned(
                        left: 0.0,
                        right: 0.0,
                        top: 0.0,
                        bottom: 0.0,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration:
                              const BoxDecoration(color: materialYouBlack),
                          child: RTCVideoView(_remoteRenderer),
                        )),
                    isSmallWindowOpened
                        ? Positioned(
                            left: 20.0,
                            top: 20.0,
                            child: Container(
                              width: orientation == Orientation.portrait
                                  ? 90.0
                                  : 120.0,
                              height: orientation == Orientation.portrait
                                  ? 120.0
                                  : 90.0,
                              decoration:
                                  const BoxDecoration(color: materialYouBlack),
                              child: RTCVideoView(_localRenderer, mirror: true),
                            ),
                          )
                        : Container(),
                  ]),
                );
              })
            : ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                itemCount: (_peers.length),
                itemBuilder: (context, i) {
                  return _buildRow(context, _peers[i]);
                }),
      ),
    );
  }
}
