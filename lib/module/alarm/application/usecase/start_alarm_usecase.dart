import 'package:meta/meta.dart';
import 'package:tasking/module/alarm/domain/alarm.dart';
import 'package:tasking/module/alarm/domain/alarm_repository.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_content.dart';
import 'package:tasking/module/alarm/domain/vo/alarm_id.dart';
import 'package:tasking/module/scene/domain/scene_repository.dart';
import 'package:tasking/module/scene/domain/vo/scene_id.dart';
import 'package:tasking/module/shared/application/exception.dart';
import 'package:tasking/module/shared/application/result.dart';
import 'package:tasking/module/shared/domain/event.dart';
import 'package:tasking/module/shared/domain/transaction.dart';

/// start alarm command dto
@immutable
class StartAlarmCommand {
  final String sceneID;
  final String content;

  const StartAlarmCommand({
    required this.sceneID,
    required this.content,
  });
}

/// start alarm usecase
class StartAlarmUseCase {
  final AlarmRepository _repository;
  final SceneRepository _sceneRepository;
  final Transaction _transaction;
  final DomainEventBus _eventBus;

  StartAlarmUseCase({
    required AlarmRepository repository,
    required SceneRepository sceneRepository,
    required Transaction transaction,
    required DomainEventBus eventBus,
  })  : _repository = repository,
        _sceneRepository = sceneRepository,
        _transaction = transaction,
        _eventBus = eventBus;

  Future<AppResult<AlarmID, ApplicationException>> execute(
    StartAlarmCommand command,
  ) async {
    return await AppResult.monitor(() async {
      final alarm = await _transaction.transaction<Alarm>(() async {
        final scene = await _sceneRepository.findByID(SceneID(command.sceneID));

        if (scene == null) {
          throw NotFoundException(command.sceneID);
        }

        final alarm = StartedAlarm.start(
          id: AlarmID.generate(),
          content: AlarmContent(command.content),
          scene: scene,
        );

        await _repository.store(alarm);

        return alarm;
      });

      _eventBus.publishes(alarm.pullDomainEvents());

      return alarm.id;
    });
  }
}
