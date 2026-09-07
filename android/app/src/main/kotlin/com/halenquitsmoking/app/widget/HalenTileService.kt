package com.halenquitsmoking.app.widget

import android.content.Intent
import android.net.Uri
import android.service.quicksettings.TileService
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

/**
 * Quick-settings tile (report §11/§27): one tap from any screen enqueues a
 * cigarette record (source=tile) via home_widget's background receiver —
 * no app launch, no UI.
 */
class HalenTileService : TileService() {
    override fun onClick() {
        super.onClick()
        val pending: PendingIntent = HomeWidgetBackgroundIntent.getBroadcast(
            this,
            Uri.parse("halen://quicklog?source=tile"),
        )
        pending.send()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return super.onStartCommand(intent, flags, startId)
    }
}
