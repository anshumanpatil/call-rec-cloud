class RecordingsRepositoryConstants {
  static const String downloadsDirectoryType = "RECORDINGS/CALL";
  static const String unableToDetermineDownloadsFolder =
      'Unable to determine downloads folder.';
  static const String downloadsFolderNotFound = 'Downloads folder not found:';
  static const String manageExternalStoragePermissionError =
      'Manage external storage permission is required to access Downloads.';
  static const String homeTitle = 'Recording Saver';
}

class AppStrings {
  // Page Titles
  static const String aboutUsTitle = 'About Us';
  static const String settingsTitle = 'Settings';

  // About Us Page
  static const String aboutUsHeading = 'About Us';
  static const String aboutUsDescription1 =
      'This app helps you browse your downloads directory in one place.';
  static const String aboutUsDescription2 =
      'You can refresh downloads, inspect files, and manage selections.';
  static const String returnToMainButton = 'Return to main';

  // Settings Page
  static const String settingsHeading = 'Settings';
  static const String settingsDescription =
      'Manage app preferences and permissions here.';

  // Drawer Menu
  static const String downloadsMenuTitle = 'Downloads Menu';
  static const String refreshDownloadsMenu = 'Refresh Downloads';
  static const String aboutMenu = 'About';
  static const String settingsMenu = 'Settings';

  // Recordings Page
  static const String initializingMessage =
      'Initializing app and checking permissions...';
  static const String permissionGrantedMessage =
      'Permission granted, loading recordings...';
  static const String refreshTooltip = 'Refresh';

  // Recordings List
  static const String selectAllLabel = 'Select All';

  // Asset Paths
  static const String splashBackgroundImage = 'assets/images/bg1.png';
  static const String appLogoImage = 'assets/images/logo.png';
}

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String about = '/about';
  static const String settings = '/settings';
}
