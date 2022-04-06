import 'package:tasking/module/shared/infrastructure/initializer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneInitializer implements Initializable {
  @override
  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(
      dotenv.get('TIMEZONE_LOCATION', fallback: 'Asia/Tokyo'),
    ));
  }
}
