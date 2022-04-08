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
## フローモードでタスクを管理する
フローモードとは、進捗状況の流れであるフローによって、タスクを管理する方法となります。

### Step1. シーンの作成
まず、シーンページの右下端にある「＋」ボタンから新規シーンを**フロー**モードに設定して作成します。

### Step2. フローの編集
シーンを作成したら、各シーンリストの「矢印マーク」ボタンをタップしてフローページを開き、右下端にある「＋」ボタンから新規オペレーションを作成します。
作成したオペレーションは、タスクの進捗順で並べ替えることができます。

### Step3. タスクの作成
フローを編集したら、シーンページに戻りタスク管理をしたい対象シーンのタイトルをタップしてタスクページを開きます。そして、右下端にある「＋」ボタンから新規タスクを作成します。

### Step4. オペレーションの変更
タスクを作成したら、タスクの内容と共にオペレーションタグが表示されるので、タグをタップして次の進捗のオペレーションに変更します。

　

　

## アラームモードでタスクを管理する
アラームモードとは、アラームによる定期的な通知によって、タスクを管理する方法となります。

### Step1. シーンの作成
まず、シーンページの右下端にある「＋」ボタンから新規シーンを**アラーム**モードに設定して作成します

### Step2. タスクの作成
シーンを作成したら、タスク管理をしたい対象シーンのタイトルをタップしてタスクページを開きます。そして、右下端にある「＋」ボタンから新規タスクを作成します。

### Step3. アラームの追加
タスクを作成すると、各タスクリストの「時計マーク」ボタンをタップしてアラーム設定ページを開き、右下端にある「＋」ボタンから新規アラームを作成します。

　

　

**以上のステップでタスクを管理していきましょう！**
          ''',
        ),
        color: Colors.white,
      ),
    );
  }
}
