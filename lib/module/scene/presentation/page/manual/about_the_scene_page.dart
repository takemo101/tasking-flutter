import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AboutTheScenePage extends StatelessWidget {
  const AboutTheScenePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('シーンについて'),
      ),
      body: Container(
        child: const Markdown(
          data: '''
## シーンとは？
シーンとは、タスクを管理する単位のことです。
シーンを作成することで、シーンに対するタスクを追加できるようになります。

　

　

## シーンネームについて
シーンに設定するシーンネームには、同じ名前を使うことができません。

　

　

## 管理モードについて
シーンには管理モードという、タスクの管理する方法を設定することができます。

　

　

### フローモード
フローモードとは、タスクを進捗状況の流れであるフローで管理していく方法となります。
フローモードに設定すると、シーンに対するフローを編集できるようになります。

### アラームモード
アラームモードとは、アラームによる定期的な通知によって、タスクを時間で管理していく方法となります。
アラームモードにすると、タスクに対してアラームを複数追加できるようになります。

　

　

## シーンの削除について
シーンを削除すると、シーンに対するタスク・フロー・アラームも全て削除されますので、注意して削除してください。

          ''',
        ),
        color: Colors.white,
      ),
    );
  }
}
