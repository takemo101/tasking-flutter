import 'package:tasking/module/shared/infrastructure/initializer.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SQLiteInitializer implements Initializable {
  @override
  Future<void> initialize() async {
    await SQLiteHelper(
      name: 'database.sqlite',
      version: int.parse(dotenv.get('SQLITE_DATABASE_VERSION', fallback: '1')),
    ).open();
  }
}
