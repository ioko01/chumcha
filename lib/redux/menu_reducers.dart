import 'package:chumcha/interfaces/interface_menu.dart';

enum MenuActions { increment, decrement, reset }

enum TempMenuActions { open, close }

enum FilterMenuActions { increment, decrement, reset }

enum ToppingMenuActions { increment, decrement, reset }

List<IMenu> menuReducer(List<IMenu> state, dynamic action) {
  if (action.action == MenuActions.increment) {
    state.add(action.state);
  }
  if (action.action == MenuActions.decrement) {
    state.removeAt(action.state);
  }
  if (action.action == MenuActions.reset) {
    state.clear();
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

List<String> filterMenuReducer(List<String> state, dynamic action) {
  if (action.action == FilterMenuActions.increment) {
    state.add(action.state);
  }
  if (action.action == FilterMenuActions.decrement) {
    state.removeAt(action.state);
  }
  if (action.action == FilterMenuActions.reset) {
    state.clear();
  }
  return state;
}

