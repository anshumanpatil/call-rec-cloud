package com.phoenix.callrecordingutil.helper

import java.io.File
import kotlin.collections.mutableListOf

object InternalValues {
    public lateinit var recordingsFolder: File
    private var filenamesToShow: MutableList<String> = mutableListOf<String>()
    private var filenamesFullPath: MutableList<String> = mutableListOf<String>()
    private var diramesToShow: MutableList<String> = mutableListOf<String>()

    fun setFileNames(files: Array<File>?): MutableList<String> {

        if (files != null) {
            if(files.size == 0){
                filenamesToShow = mutableListOf("No files found")
            }
            for (file in files) {
                if (file.isFile) {
                    val f = displayFileData(file)

                    CallLogger.sendLog( "File fileFullPath: ${f.fileFullPath}")
                    CallLogger.sendLog("File fileName : ${f.fileName}")
                    CallLogger.sendLog("File fileNameOnServer : ${f.fileNameOnServer}")
                    CallLogger.sendLog("File fileDirectory : ${f.fileDirectory}")






                    filenamesToShow.add(f.fileName)

                } else if (file.isDirectory) {
                    CallLogger.sendLog( "Directory Name: ${file.name}")
                    diramesToShow.add("Dir - " + file.name)
                }
            }
        } else {
            CallLogger.sendLog("Directory is null or empty, or path issues.")
        }


        return filenamesToShow
    }

    fun displayFileData(fileObj: File): FileUploadObject {
        val f = FileUploadObject
        f.fileName = fileObj.name
        f.fileFullPath = fileObj.absolutePath

        val rem = f.fileName.replace("Call recording", "")
        val spl = rem.split("_")
        val nm = spl[0]
        val dat = spl[1]
        val tm = spl[2]
        val newdatyr = dat.substring(0..1)
        val newdatmon = dat.substring(2..3)
        val newdatdd = dat.substring(4..5)
//        CallLogger.sendLog(newdatdd)
//        CallLogger.sendLog(newdatmon)
//        CallLogger.sendLog(newdatyr)
        f.fileDirectory = "${newdatdd}-${newdatmon}-${newdatyr}"
        f.fileNameOnServer = nm.trimStart().split(" ").joinToString(separator = "_") + "_" + tm
        return f
    }
}