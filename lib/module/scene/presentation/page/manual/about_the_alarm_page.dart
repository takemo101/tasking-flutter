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
アラームで設定した時間に定期的にタスクを通知することで、タスクを時間で管理します。

タスクに対してアラームを複数追加することができ、時間と曜日を設定して追加すると、毎週定期的にアラーム通知がされるようになります。

　

　

## 通知時間について
ひとつのタスクに対して追加するアラームの通知時間は、同じ時間を設定することはできません。

　

　

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
