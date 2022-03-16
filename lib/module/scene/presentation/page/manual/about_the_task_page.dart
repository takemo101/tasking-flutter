import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AboutTheTaskPage extends StatelessWidget {
  const AboutTheTaskPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('タスクについて'),
      ),
      body: Container(
        child: const Markdown(
          data: '''
## タスクはどう管理していく？
タスクを追加したら、タスクの内容と共に割り当てられたオペレーションのタグが表示されているので、タグをタップすることで次のオペレーションに変更することができます。

つまり、タスクのオペレーションを進捗状況に応じて変更することで管理していきます。

## タスクの整頓について
タスクは基本的に追加した順に表示されるようになっているのですが、タスクページの右上にある「整頓」ボタンをタップすることで、フローの並び順でタスクを整頓することができます。

## タスクの破棄について
完了したタスクは、対象タスクの右端にある「x」マークをタップすることで、破棄することができます。

破棄したタスクは、破棄タスクリストとして表示されます。
破棄したタスクを、通常のタスクに戻したい場合は、破棄タスクリストから対象のタスクの「矢印」マークをタップすることで、戻すことができます。

## タスクの削除について
タスクを削除するには、一度タスクを破棄して破棄タスクリストに入れる必要があります。

そして、破棄タスクリストから対象のタスクの「ゴミ箱」マークをタップすることで、完全に削除することができます。

          ''',
        ),
        color: Colors.white,
      ),
    );
  }
}
