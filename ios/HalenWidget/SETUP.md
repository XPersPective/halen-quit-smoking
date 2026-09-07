# HalenWidget — iOS Widget Extension setup

The Swift sources in this folder implement the home widget (iOS 17+
interactive), the iOS 18 ControlWidget (lock screen / control center) and the
App Intent both use to quick-log without opening the app (report §11/§27).

Xcode cannot add extension targets from the CLI, so the target wiring is a
one-time manual step (macOS only):

1. Open `ios/Runner.xcworkspace` in Xcode.
2. File → New → Target… → **Widget Extension**, name it `HalenWidget`,
   uncheck "Include Configuration Intent".
3. Delete the template Swift files it creates and add the files from this
   folder to the new target instead.
4. Target → Signing & Capabilities → add the **App Groups** capability with
   `group.com.halenquitsmoking.shared` (use `HalenWidget.entitlements` here
   and `Runner/HalenRunner.entitlements` on the Runner target).
5. Ensure the widget's `@main` bundle kind (`halen_widget`) matches the
   `iOSName` used by the Dart side (`HalenWidget` file name in
   `lib/data/widget_service.dart`).
6. Build & run on device/simulator; long-press the home screen to add the
   widget.

The GitHub Actions `macos-latest` job builds the main Runner target; the
widget target compiles as part of `flutter build ipa` once wired (it is a
standard extension target with no extra packages).
