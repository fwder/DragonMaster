import 'package:flutter/material.dart';
import 'main.dart';

const double _maxWidthConstraint = 400;
const _colDivider = SizedBox(height: 10);

class DragonMasterAboutScreen extends StatelessWidget {
  const DragonMasterAboutScreen({super.key});

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
                      '龙虎 / DragonMaster $appVersionName\n\n基于 flutter_webrtc 开发。\n\nCopyright © Weclont\n\n本应用遵循 Apache License 2.0 协议。',
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
