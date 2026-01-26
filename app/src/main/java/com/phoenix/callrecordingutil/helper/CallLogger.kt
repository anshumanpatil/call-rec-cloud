package com.phoenix.callrecordingutil.helper

import android.util.Log

object CallLogger {
    // Properties and functions go here
    var tagName: String = "CallLogger"

    fun sendLog(msgOfLog: String) {
        Log.d(tagName, msgOfLog)
    }
}