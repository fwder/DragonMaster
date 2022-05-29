import 'package:dragonmaster/utils/sputils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';

const double _maxWidthConstraint = 400;
const _colDivider = SizedBox(height: 10);

enum DialogDemoAction {
  cancel,
  connect,
}

class DragonMasterSettingsScreen extends StatelessWidget {
  const DragonMasterSettingsScreen({super.key});

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
              children: const [
                _colDivider,
                ServerSettingDialogs(),
                _colDivider,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ServerSettingDialogs extends StatefulWidget {
  const ServerSettingDialogs({super.key});

  @override
  State<ServerSettingDialogs> createState() => _ServerSettingDialogsState();
}

class _ServerSettingDialogsState extends State<ServerSettingDialogs> {
  addressSettingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => addressSettingDialogBuilder(),
    );
  }

  Widget addressSettingDialogBuilder() {
    final TextEditingController textFieldController = TextEditingController();
    return AlertDialog(
        title: const Text(
          '请输入服务器地址：',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        content: TextField(
          controller: textFieldController,
          decoration: InputDecoration(
            hintText: SpUtils.getString('server'),
          ),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context, DialogDemoAction.cancel);
              }),
          TextButton(
              child: const Text('确定'),
              onPressed: () {
                if (textFieldController.text != '') {
                  SpUtils.putString('server', textFieldController.text);
                  Fluttertoast.showToast(msg: '保存成功');
                  if (kDebugMode) {
                    print('保存成功，重新读取到：${SpUtils.getString('server')}');
                  }
                } else {
                  if (SpUtils.getString('server') == '' || SpUtils.getString('server') == 'noDetected'){
                    if (kDebugMode) {
                      print('输入的地址不可为空');
                    }
                    Fluttertoast.showToast(msg: '输入的地址不可为空');
                  } else {
                    if (kDebugMode) {
                      print('保存成功');
                    }
                    Fluttertoast.showToast(msg: '保存成功');
                  }
                }
                Navigator.pop(context, DialogDemoAction.connect);
              })
        ]);
  }

  // 夜间模式切换
  ThemeData updateThemes(bool useLightModer) {
    return ThemeData(
        colorSchemeSeed: themeColor,
        useMaterial3: true,
        brightness: useLightModer ? Brightness.light : Brightness.dark);
  }

  handleBrightnessChange() {
    appSetState(() {
      useLightMode = !useLightMode;
      themeData = updateThemes(useLightMode);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: const Align(
            alignment: Alignment(-0.9, 0.0),
            child: Text('设置服务器'),
          ),
          onTap: () => addressSettingDialog(context),
        ),
        Container(
          margin: const EdgeInsets.all(5.0),
        ),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title: useLightMode
              ? const Align(
                  alignment: Alignment(-0.9, 0.0),
                  child: Text('切换到夜间模式'),
                )
              : const Align(
                  alignment: Alignment(-0.9, 0.0),
                  child: Text('切换到日间模式'),
                ),
          onTap: () => handleBrightnessChange(),
        ),
      ],
    );
  }
}
