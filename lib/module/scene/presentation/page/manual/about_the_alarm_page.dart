import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AboutTheAlarmPage extends StatelessWidget {
  const AboutTheAlarmPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('アラームについて'),
      ),
      body: Container(
        child: const Markdown(
          data: '''
## アラームとは？
アラームとは、タスクを通知する時間設定のことです。

タスクに対してアラームを複数追加することができ、アラームには定期通知を行うための時間と曜日を設定することができ、毎週定期的に設定した時間と曜日にアラーム通知がされるようになります。

## 通知時間について
ひとつのタスクに対して設定するアラームの通知時間は、同じ時間を設定することはできません。

## アラームのOn/Offについて
タスクに追加した各アラームは、OnとOffを切り替えられるようになっており、Offにすることで通知しないようにすることができます。

## アラームの限度数について
ひとつのタスクに対してアラームは、7個以上追加することはできません。
          ''',
        ),
        color: Colors.white,
      ),
    );
  }
}
