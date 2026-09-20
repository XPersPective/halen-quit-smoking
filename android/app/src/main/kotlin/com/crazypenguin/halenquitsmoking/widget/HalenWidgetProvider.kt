package com.crazypenguin.halenquitsmoking.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.res.Configuration
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import com.crazypenguin.halenquitsmoking.R
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

/**
 * Home-screen widget (report §27): shows today's progress
 * ("4/8 · 1h 12m") with a one-tap quick-log button.
 *
 * The button fires a broadcast to home_widget's background receiver, which
 * runs the Dart [quickLogCallback] in a background isolate and enqueues the
 * record (source=widget). The main app drains the queue and calls
 * `HomeWidget.updateWidget` to refresh the numbers here.
 */
class HalenWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (id in appWidgetIds) {
            appWidgetManager.updateAppWidget(id, buildViews(context))
        }
    }

    override fun onEnabled(context: Context) {
        // Request fresh numbers on the next app open; the static layout
        // shows placeholders until then.
        super.onEnabled(context)
    }

    companion object {
        fun buildViews(context: Context): RemoteViews {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val count = prefs.getInt("todayCount", 0)
            val target = prefs.getInt("todayTarget", 0)
            val summary = prefs.getString("todaySummary", "--/--")
                ?: "--/--"

            // T7: the app pushes widgetTheme = system | light | dark into the
            // same HomeWidget store, so both re-render on the choice.
            val theme = prefs.getString("widgetTheme", "system") ?: "system"
            val night = (context.resources.configuration.uiMode and
                Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES
            val dark = when (theme) { "dark" -> true; "light" -> false; else -> night }

            val bg = if (dark) 0xFF1E4D45.toInt() else 0xFFF6F4EE.toInt()
            val fg = if (dark) 0xFFFFFFFF.toInt() else 0xFF1C1B16.toInt()
            val btnBg = 0xFFF5A623.toInt()
            val btnFg = 0xFF1E1B16.toInt()

            val views = RemoteViews(context.packageName, R.layout.halen_widget)
            views.setInt(R.id.widget_root, "setBackgroundColor", bg)
            views.setTextViewText(R.id.widget_summary, summary)
            views.setTextViewText(R.id.widget_title, "Halen")
            views.setTextColor(R.id.widget_title, fg)
            views.setTextColor(R.id.widget_summary, fg)
            views.setInt(R.id.widget_log_button, "setBackgroundColor", btnBg)
            views.setTextColor(R.id.widget_log_button, btnFg)

            // Quick-log broadcast (source=widget) — no app launch.
            val logIntent: PendingIntent = HomeWidgetBackgroundIntent.getBroadcast(
                context,
                Uri.parse("halen://quicklog?source=widget"),
            )
            views.setOnClickPendingIntent(R.id.widget_log_button, logIntent)

            // Tapping the text opens the app (launch intent handled by the
            // plugin's activity path).
            val openIntent = PendingIntent.getActivity(
                context,
                1,
                Intent(context, Class.forName("com.crazypenguin.halenquitsmoking.MainActivity")),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_summary, openIntent)
            return views
        }

        /** Refresh all instances (called from MainActivity on resume). */
        fun refreshAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, HalenWidgetProvider::class.java),
            )
            val views = buildViews(context)
            for (id in ids) {
                manager.updateAppWidget(id, views)
            }
        }
    }
}
