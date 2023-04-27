import 'dart:io';

class IsDevice {
  bool isMobile() {
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  bool isDesktop() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return true;
    } else {
      return false;
    }
  }
}
