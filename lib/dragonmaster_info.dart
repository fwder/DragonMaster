import 'package:flutter/material.dart';

const double _maxWidthConstraint = 400;

class DragonMasterInfoScreen extends StatelessWidget {
  const DragonMasterInfoScreen({super.key});

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
                      '0.2.0\n'
                      '优化 提高了分辨率和帧率\n'
                      '优化 启用了更小的延时\n'
                      '优化 连接页面:设备信息的显示格式\n'
                      '优化 代码结构\n'
                      '修复 连接后必须刷新才能显示视频流的问题\n'
                      '修复 在建立连接后被邀请端无法自动弹出小窗显示的问题\n\n'
                      '0.1.0\n'
                      '新增 视频传输\n'
                      '新增 屏幕共享\n',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
