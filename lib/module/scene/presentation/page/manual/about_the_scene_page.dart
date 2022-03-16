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
シーンを作成することで、シーンに対するタスクを追加と、タスクの進捗状況であるフローを編集できるようになります。

## シーンネームについて
シーンに設定するシーンネームには、同じ名前を使うことができません。

## シーンの削除について
シーンを削除すると、シーンに対するタスクとフローも全て削除されますので、注意して削除してください。

          ''',
        ),
        color: Colors.white,
      ),
    );
  }
}
