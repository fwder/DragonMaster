import 'dragonmaster_connections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dragonmaster_home.dart';
import 'dragonmaster_settings.dart';
import 'dragonmaster_about.dart';
import 'dragonmaster_info.dart';
import './utils/sputils.dart';

const appVersionName = "0.2.0";
const appVersionNum = '2';
const appName = 'DragonMaster';
const packageName = 'com.weclont.DragonMaster';
final List<Widget> _pages = [
  const DragonMasterHomeScreen(),
  const DragonMasterConnectionScreen(),
  const DragonMasterSettingsScreen(),
  const DragonMasterInfoScreen(),
  const DragonMasterAboutScreen(),
]; //用于存放对应的页面
const List<String> _pagesName = <String>[
  "DragonMasterHomeScreen",
  "DragonMasterConnectionScreen",
  "DragonMasterSettingsScreen",
  "DragonMasterInfoScreen",
  "DragonMasterAboutScreen",
]; //用于存放对应的页面名称
const double narrowScreenWidthThreshold = 450;
const Color themeColor = Color(0xff6750a4);
List<String> settingConnectedText = <String>[
  "刷新",
  "打开麦克风",
  "打开小窗",
  "切换摄像头",
  "断开连接",
];
const List<String> settingNotConnectedText = <String>[
  "关于",
];
const materialYouBlack = Color.fromARGB(255, 28, 27, 30);
const materialYouWhite = Color.fromARGB(255, 230, 225, 229);
const double buttonMargin = 8.0;
const double buttonPadding = 3.0;
late Function appSetState;
int screenIndex = 0;
bool useLightMode = false;
bool deviceIsConnected = false;
ThemeData themeData = ThemeData(
    colorSchemeSeed: themeColor,
    useMaterial3: true,
    brightness: useLightMode ? Brightness.light : Brightness.dark);

void main() {
  runApp(const DragonMasterApp());
}

class DragonMasterApp extends StatefulWidget {
  const DragonMasterApp({super.key});

  @override
  State<DragonMasterApp> createState() => _DragonMasterAppState();
}

class _DragonMasterAppState extends State<DragonMasterApp> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initUtils();
    _initSetState();
  }

  _initSetState() {
    appSetState = setState;
  }

  _initUtils() async {
    await SpUtils.getInstance();
    if (kDebugMode) {
      print('工具类初始化成功');
    }
  }

  // 夜间模式切换
  ThemeData updateThemes(bool useLightModer) {
    return ThemeData(
        colorSchemeSeed: themeColor,
        useMaterial3: true,
        brightness: useLightModer ? Brightness.light : Brightness.dark);
  }

  // 监控黑夜模式变化
  void handleBrightnessChange() {
    setState(() {
      useLightMode = !useLightMode;
      themeData = updateThemes(useLightMode);
    });
  }

  // 监控未连接菜单选择
  void handleMenuNotConnectedSelect(int value) {
    setState(() {
      screenIndex = 4;
    });
  }

  // 监控连接菜单选择
  void handleMenuConnectedSelect(int value) {
    switch (value) {
      case 0:
        rc();
        break;
      case 1:
        mm();
        break;
      case 2:
        hswo();
        break;
      case 3:
        sc();
        break;
      case 4:
        hp();
        break;
      default:
        hp();
        break;
    }
  }

  Widget createScreenFor(int screenIndex) {
    return _pages[screenIndex];
  }

  PreferredSizeWidget createAppBar() {
    return AppBar(
      title: const Text("DragonMaster"),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          itemBuilder: (context) {
            return List.generate(deviceIsConnected
                ? settingConnectedText.length
                : settingNotConnectedText.length, (index) {
              return PopupMenuItem(
                value: index,
                child: Wrap(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(deviceIsConnected
                            ? settingConnectedText[index]
                            : settingNotConnectedText[index])),
                  ],
                ),);
            });
          },
          onSelected: deviceIsConnected ? handleMenuConnectedSelect : handleMenuNotConnectedSelect,
          tooltip: '选项',
        ),
      ],
    );
  }

  void handleRouteSelect(int ri) {
    if (kDebugMode) {
      print("您正在设置页面：${_pagesName[ri]}");
    }
    setState(() {
      screenIndex = ri;
      _scaffoldkey.currentState?.closeDrawer();
    });
  }

  Widget buttonContainer(IconData icd, String s, bool ltmd, int ri) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton.icon(
          icon: Icon(
            icd,
            color: ltmd ? materialYouBlack : Colors.white,
          ),
          onPressed: () => handleRouteSelect(ri),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(300, 70),
            primary: ltmd ? Colors.white : materialYouBlack,
            onSurface: ltmd ? materialYouWhite : materialYouBlack,
            shadowColor: ltmd ? materialYouWhite : materialYouBlack,
            side: BorderSide(
              color: ltmd ? Colors.white : materialYouBlack,
              width: 0.0,
            ),
            surfaceTintColor: ltmd ? Colors.purple[100] : materialYouBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          label: Align(
            alignment: const Alignment(-0.98, 0.0),
            child: Text(
              s,
              style: TextStyle(
                  color: ltmd ? materialYouBlack : materialYouWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          )),
    );
  }

  Widget dragonMasterAppDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: 20,
            width: 0,
          ),
          useLightMode
              ? buttonContainer(Icons.home, '主页', true, 0)
              : buttonContainer(Icons.home_outlined, '主页', false, 0),
          useLightMode
              ? buttonContainer(Icons.sync, '连接', true, 1)
              : buttonContainer(Icons.sync_outlined, '连接', false, 1),
          useLightMode
              ? buttonContainer(Icons.settings, '设置', true, 2)
              : buttonContainer(Icons.settings_outlined, '设置', false, 2),
          useLightMode
              ? buttonContainer(Icons.insert_drive_file, '日志', true, 3)
              : buttonContainer(
              Icons.insert_drive_file_outlined, '日志', false, 3),
          useLightMode
              ? buttonContainer(Icons.info, '关于', true, 4)
              : buttonContainer(Icons.info_outline, '关于', false, 4),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DragonMaster',
      themeMode: useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: themeData,
      home: LayoutBuilder(builder: (context, constraints) {
        // if (constraints.maxWidth < narrowScreenWidthThreshold) {
        //   return Scaffold(
        //     key: _scaffoldkey,
        //     appBar: createAppBar(),
        //     body: Row(children: <Widget>[
        //       createScreenFor(screenIndex),
        //     ]),
        //     drawer: dragonMasterAppDrawer(),
        //   );
        // } else {
        //   return Scaffold(
        //     key: _scaffoldkey,
        //     appBar: createAppBar(),
        //     body: SafeArea(
        //       bottom: false,
        //       top: false,
        //       child: Row(
        //         children: <Widget>[
        //           const VerticalDivider(thickness: 1, width: 1),
        //           createScreenFor(screenIndex),
        //         ],
        //       ),
        //     ),
        //     drawer: dragonMasterAppDrawer(),
        //   );
        // }
        return Scaffold(
          key: _scaffoldkey,
          appBar: createAppBar(),
          body: Row(children: <Widget>[
            createScreenFor(screenIndex),
          ]),
          drawer: dragonMasterAppDrawer(),
        );
      }),
    );
  }
}
