import 'package:dragonmaster/utils/sputils.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'main.dart';

const double _maxWidthConstraint = 400;

class DragonMasterHomeScreen extends StatefulWidget {
  static String tag = 'DragonMasterHomeScreen';

  const DragonMasterHomeScreen({super.key});

  @override
  State<DragonMasterHomeScreen> createState() => DragonMasterHomeScreenState();
}

class DragonMasterHomeScreenState extends State<DragonMasterHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: _maxWidthConstraint,
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    margin: const EdgeInsets.all(3.0),
                    padding: const EdgeInsets.all(4.0),
                    child: const Text(
                      '龙虎 - $appVersionName\n                                ——通用便捷的投屏工具。\n\n点击下面的按钮开始使用。',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Dialogs(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Dialogs extends StatefulWidget {
  const Dialogs({super.key});

  @override
  State<Dialogs> createState() => _DialogsState();
}

class _DialogsState extends State<Dialogs> {
  void openDialog(BuildContext context) {
    (SpUtils.getString('server') != null && SpUtils.getString('server') != '')
        ? showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("提示"),
              content: Text(
                  "当前设置的服务器地址为：\n${SpUtils.getString('server')}\n\n需要重新设置服务器地址吗？"),
              actions: <Widget>[
                TextButton(
                  child: const Text('进入设置'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    appSetState(() {
                      screenIndex = 2;
                    });
                  },
                ),
                TextButton(
                  child: const Text('直接连接'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    appSetState(() {
                      screenIndex = 1;
                    });
                  },
                ),
              ],
            ),
          )
        : showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("提示"),
              content: const Text("您还没有设置可用的服务器地址。"),
              actions: <Widget>[
                TextButton(
                  child: const Text('进入设置'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    appSetState(() {
                      screenIndex = 2;
                    });
                  },
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
        child: const Text(
          "进入连接页面",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => openDialog(context),
      ),
    );
  }
}
