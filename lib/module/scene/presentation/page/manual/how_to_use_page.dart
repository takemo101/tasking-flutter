import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HowToUsePage extends StatelessWidget {
  const HowToUsePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('アプリの利用手順'),
      ),
      body: Container(
        child: const Markdown(
          data: '''
## Step1. シーンの作成
まず、シーンページの右下端にある「＋」ボタンから新規シーンを作成します。
タスクを管理する場面に応じたシーンを作成しましょう！

## Step2. フローの編集
シーンを作成したら、各シーンリストの右端のアイコンをタップしてフローページを開き、右下端にある「＋」ボタンから新規オペレーションを作成します。
作成したオペレーションは、タスクの進捗順で並べ替えることができます。

## Step3. タスクの作成
フローを編集したら、シーンページに戻りタスク管理をしたい対象シーンのタイトルをタップしてタスクページを開きます。そして、右下端にある「＋」ボタンから新規タスクを作成します。

## Step4. オペレーションの変更
タスクを作成すると、タスクの内容と共にオペレーションタグが表示され、タグをタップすると次の進捗のオペレーションに変更することができます。

完了したタスクは、各タスクの端にある「x」ボタンをタップすることで破棄することができます。

**以上のステップでタスクを管理していきましょう！**
          ''',
        ),
        color: Colors.white,
      ),
    );
  }
}
