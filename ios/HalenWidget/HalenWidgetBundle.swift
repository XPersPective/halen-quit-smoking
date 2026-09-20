import WidgetKit
import SwiftUI

// MARK: - Shared constants

/// App Group shared between the Runner and the widget extension. The Dart
/// side (home_widget) writes todayCount / todayTarget / todaySummary here;
/// the interactive buttons write a pending quick-log marker that the main
/// app drains on its next launch/resume (see QuickLogQueue in Dart).
enum HalenShared {
    static let appGroup = "group.com.halenquitsmoking.shared"

    static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroup)
    }

    static var summary: String {
        defaults?.string(forKey: "todaySummary") ?? "--/--"
    }

    /// T7: widget look chosen in the app's Settings ("system" | "light" |
    /// "dark"), shared in the same App Group store.
    static var theme: String {
        defaults?.string(forKey: "widgetTheme") ?? "system"
    }
}

// MARK: - Quick-log App Intent (iOS 17+ interactivity, report §27)

/// Runs WITHOUT opening the app: appends a pending quick-log marker to the
/// App Group storage. The main app drains it on next launch/resume and
/// records the cigarette with source=widget/control.
struct LogCigaretteIntent: AppIntent {
    static let title: LocalizedStringResource = "Log cigarette"
    static let description = IntentDescription("Adds today's cigarette record.")

    /// widget = home widget; control = iOS 18 control / lock screen.
    @Parameter(title: "Source") var source: String

    init() {}

    init(source: String) {
        self.source = source
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        let defaults = HalenShared.defaults
        var queue = defaults?.stringArray(forKey: "quickLogQueue") ?? []
        queue.append(source)
        defaults?.set(queue, forKey: "quickLogQueue")

        // Optimistic surface update: bump the count shown on the widget.
        let current = defaults?.integer(forKey: "todayCount")
        defaults?.set(current + 1, forKey: "todayCount")
        WidgetCenter.shared.reloadTimelines(ofKind: "halen_widget")
        return .result()
    }
}

// MARK: - Timeline entry / view

struct HalenEntry: TimelineEntry {
    let date: Date
    let summary: String
}

struct HalenProvider: TimelineProvider {
    func placeholder(in context: Context) -> HalenEntry {
        HalenEntry(date: Date(), summary: "--/--")
    }

    func getSnapshot(in context: Context, completion: @escaping (HalenEntry) -> Void) {
        completion(HalenEntry(date: Date(), summary: HalenShared.summary))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HalenEntry>) -> Void) {
        let entry = HalenEntry(date: Date(), summary: HalenShared.summary)
        // Refresh at the top of the next hour; taps already update optimistically.
        let next = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }
}

struct HalenWidgetView: View {
    var entry: HalenEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Halen")
                .font(.caption)
                .foregroundStyle(HalenStyle.header)
            Text(entry.summary)
                .font(.system(.title2, design: .rounded).bold())
                .foregroundStyle(HalenStyle.body)
            // iOS 17+ interactive button — logs without opening the app.
            if #available(iOS 17.0, *) {
                Button(intent: LogCigaretteIntent(source: "widget")) {
                    Text("+1")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.96, green: 0.65, blue: 0.14))
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(HalenStyle.background, for: .widget)
    }
}

// MARK: - Widget

struct HalenWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "halen_widget", provider: HalenProvider()) { entry in
            HalenWidgetView(entry: entry)
        }
        .configurationDisplayName("Halen")
        .description("Today's progress and one-tap logging.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - iOS 18 Control Widget (report §11: lock screen / control center)

@available(iOS 18.0, *)
struct LogCigaretteControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "halen_log_control") {
            ControlWidgetButton(action: LogCigaretteIntent(source: "control")) {
                Label("Log", systemImage: "checkmark.circle")
            }
        }
        .displayName("Halen quick log")
    }
}

// MARK: - Bundle
//
// Single @main: on iOS 18+ the bundle also carries the control widget
// (lock screen / control center quick log).

@main
struct HalenWidgetBundle: WidgetBundle {
    var body: some WidgetBundle {
        HalenWidget()
        if #available(iOSApplicationExtension 18.0, *) {
            LogCigaretteControl()
        }
    }
}

// MARK: - Themed colors (T7)

enum HalenStyle {
    static var dark: Bool {
        switch HalenShared.theme {
        case "dark": return true
        case "light": return false
        default:
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
    }
    static var background: Color {
        dark ? Color(red: 0.118, green: 0.302, blue: 0.271)   // #1E4D45
             : Color(red: 0.965, green: 0.957, blue: 0.933)   // #F6F4EE
    }
    static var header: Color {
        dark ? .white.opacity(0.8) : Color(red: 0.11, green: 0.11, blue: 0.09, opacity: 0.7)
    }
    static var body: Color {
        dark ? .white : Color(red: 0.11, green: 0.11, blue: 0.09)
    }
}
