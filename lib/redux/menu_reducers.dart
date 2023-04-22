import 'package:chumcha/interfaces/interface_menu.dart';

enum MenuActions { increment, decrement }

enum TempMenuActions { open, close }

List<IMenu> menuReducer(List<IMenu> state, dynamic action) {
  if (action.action == MenuActions.increment) {
    state.add(action.state);
  }
  if (action.action == MenuActions.decrement) {
    state.removeAt(action.state);
  }
  return state;
}

bool tempMenuReducer(bool state, dynamic action) {
  if (action.action == TempMenuActions.open) {
    state = action.state;
  }
  if (action.action == TempMenuActions.close) {
    state = action.state;
  }
  return state;
}
