import 'dart:ui';

enum IosLockTrigger { willResignActive, didEnterBackground }

enum PrivacyBlurEffect {
  light,
  extraLight,
  dark,
  none,
}

enum PrivacyContentMode {
  scaleToFill,
  scaleAspectFit,
  scaleAspectFill,
  redraw,
  center,
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

extension PrivacyBlurEffectExtension on PrivacyBlurEffect {
  Color get color {
    switch (this) {
      case PrivacyBlurEffect.dark:
        return const Color.fromARGB(144, 0, 0, 0);
      case PrivacyBlurEffect.none:
        return const Color(0x00FFFFFF);
      default:
        return const Color.fromARGB(50, 255, 255, 255);
    }
  }

  double get blurRadius {
    switch (this) {
      case PrivacyBlurEffect.extraLight:
        return 32;
      case PrivacyBlurEffect.none:
        return 0;
      default:
        return 18;
    }
  }
}

enum AppLifeCycle {
  iosDidBecomeActive,
  iosDidEnterBackground,
  iosWillEnterForeground,
  iosWillResignActive,
  androidOnResume,
  androidOnDestroy,
  androidOnPause,
  androidOnStop,
  androidOnStart,
  androidOnCreate,
  unknown,
}

class PrivacyAndroidOptions {
  const PrivacyAndroidOptions({
    this.enableSecure = true,
    this.autoLockAfterSeconds = -1,
  });

  /// This will add [FLAG_SECURE] for android
  /// Which will hide app content in background
  /// and also disable screenshot for the whole app
  final bool enableSecure;

  /// Enable auto lock, this is irrelevant with [enableSecure]
  /// You can disable [enableSecure] and still enable auto locker
  /// Disabled when <0, enable when >= 0, delay in seconds
  /// It uses native app lifecycle to trigger instead of
  /// flutter's lifecycle, because flutter lifecycle is not accurate
  /// when going into a native viewController (eg: webview, pdfview, etc)
  /// The lockscreen only happens after onResume, android does not render
  /// in background
  final int autoLockAfterSeconds;

  factory PrivacyAndroidOptions.disable() => const PrivacyAndroidOptions(
        enableSecure: false,
        autoLockAfterSeconds: -1,
      );
}

class PrivacyIosOptions {
  const PrivacyIosOptions({
    this.enablePrivacy = true,
    this.privacyImageName,
    this.autoLockAfterSeconds = -1,
    this.lockTrigger = IosLockTrigger.didEnterBackground,
    this.privacyContentMode = PrivacyContentMode.center,
  });

  /// Enable the privacy view when app goes into background
  final bool enablePrivacy;

  /// Enable auto lock, this is irrelevant with [enablePrivacy]
  /// You can disable [enablePrivacy] and still enable auto locker
  /// Disabled when <0, enable when >= 0, delay in seconds
  /// It uses native app lifecycle to trigger instead of
  /// flutter's lifecycle, because flutter lifecycle is not accurate
  /// when going into a native viewController (eg: webview, pdfview, etc)
  final int autoLockAfterSeconds;

  /// This is the native image asset name in IOS
  /// To enable this feature, you will need
  /// to include [imageName] asset in the runner
  /// from xCode of you project and pass the
  /// [imageName] here such as "LaunchImage"
  /// Leave blank or null if you don't want to use a
  /// image in the privacyView
  final String? privacyImageName;

  /// You can choose between
  /// [IosLockTrigger.willResignActive] -> app entered app switcher (Be very careful if you want to use this approach)
  /// SwipeDown, SwipeUp (open system drawer), faceId etc will also trigger [willResignActive]
  /// - OR -
  /// [IosLockTrigger.didEnterBackground] -> app entered background (when switched to another app or home)
  final IosLockTrigger lockTrigger;

  /// Options to specify how a view adjusts its content when its size changes.
  /// [PrivacyContentMode.scaleToFill] -> The option to scale the content to fit the size of itself by changing the aspect ratio of the content if necessary.
  /// [PrivacyContentMode.scaleAspectFit] -> The option to scale the content to fit the size of the view by maintaining the aspect ratio. Any remaining area of the view’s bounds is transparent.
  /// [PrivacyContentMode.scaleAspectFill] -> The option to scale the content to fill the size of the view. Some portion of the content may be clipped to fill the view’s bounds.
  /// [PrivacyContentMode.redraw] -> The option to redisplay the view when the bounds change by invoking the setNeedsDisplay() method.
  /// [PrivacyContentMode.center] -> The option to center the content in the view’s bounds, keeping the proportions the same.
  /// [PrivacyContentMode.top] -> The option to center the content aligned at the top in the view’s bounds.
  /// [PrivacyContentMode.bottom] -> The option to center the content aligned at the bottom in the view’s bounds.
  /// [PrivacyContentMode.left] -> The option to align the content on the left of the view.
  /// [PrivacyContentMode.right] -> The option to align the content on the right of the view.
  /// [PrivacyContentMode.topLeft] -> The option to align the content in the top-left corner of the view.
  /// [PrivacyContentMode.topRight] -> The option to align the content in the top-right corner of the view.
  /// [PrivacyContentMode.bottomLeft] -> The option to align the content in the bottom-left corner of the view.
  /// [PrivacyContentMode.bottomRight] -> The option to align the content in the bottom-right corner of the view.
  final PrivacyContentMode privacyContentMode;

  factory PrivacyIosOptions.disable() => const PrivacyIosOptions(
        enablePrivacy: false,
        autoLockAfterSeconds: -1,
      );
}
