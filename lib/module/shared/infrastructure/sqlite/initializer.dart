import 'package:tasking/module/shared/infrastructure/initializer.dart';
import 'package:tasking/module/shared/infrastructure/sqlite/helper.dart';

class SQLiteInitializer implements Initializable {
  @override
  Future<void> initialize() async {
    await SQLiteHelper().open();
  }
}
