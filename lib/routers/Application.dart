import 'package:artepie/utils/shared_preferences.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fluro/fluro.dart';

class Application{
  static Router router;
  static SpUtil spUtil;
  static bool pageIsOpen = false;
  static EventBus event;
  Map<String,String> get congig{
    return {};
  }
}