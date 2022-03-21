import 'package:tasking/module/shared/infrastructure/initializer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvInitializer implements Initializable {
  @override
  Future<void> initialize() async {
    await dotenv.load();
  }
}
