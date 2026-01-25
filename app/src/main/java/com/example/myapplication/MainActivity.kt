package com.example.myapplication

import android.content.Context
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.widget.ArrayAdapter
import android.widget.ListView
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import com.example.myapplication.databinding.ActivityMainBinding
import java.io.File


class MainActivity : AppCompatActivity() {

    private lateinit var appBarConfiguration: AppBarConfiguration
    private lateinit var binding: ActivityMainBinding

    @RequiresApi(Build.VERSION_CODES.S)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(R.layout.activity_main)
        val arrayAdapter: ArrayAdapter<*>
        val context: Context = this
        val filesDirPath: String = context.filesDir.absolutePath

        val state = Environment.getExternalStorageState()
        val folderrecord = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RECORDINGS)

        Log.d("FileList", "folderrecord : $folderrecord")
        val directory = File(folderrecord.absolutePath, "/Call")
        val files: Array<File>? = directory.listFiles()
        val filenamesToShow = mutableListOf("")
        val filenamesToUpload = mutableListOf("")
        val diramesToShow = mutableListOf("")
        if (files != null) {
            Log.d("FileList", "Total files found: ${files.size}")
            for (file in files) {
                if (file.isFile) {
                    Log.d("FileList", "File Name: ${file.name}, Path: ${file.absolutePath}")
                    Log.d("FileList", "File -- : ${displayFileData(file.name)}")
                    filenamesToShow.add(displayFileData(file.name))
                    filenamesToShow.add(file.absolutePath)
                } else if (file.isDirectory) {
                    Log.d("FileList", "Directory Name: ${file.name}")
                    diramesToShow.add("Dir - " + file.name)
                }
            }
        } else {
            Log.d("FileList", "Directory is null or empty, or path issues.")
        }


        // access the listView from xml file
        val listView: ListView = findViewById(R.id.user_list)
        arrayAdapter = ArrayAdapter(this, android.R.layout.simple_list_item_1, filenamesToShow)
        listView.adapter = arrayAdapter

    }
    fun displayFileData(fName: String): String {
        val rem = fName.replace("Call recording", "")
        val spl = rem.split("_")
        val nm = spl[0]
        val dat = spl[1]
        val tm = spl[2]
        val newdatyr = dat.substring(0..1)
        val newdatmon = dat.substring(2..3)
        val newdatdd = dat.substring(4..5)
        Log.d("FileList",newdatdd)
        Log.d("FileList",newdatmon)
        Log.d("FileList",newdatyr)
        return "$nm - Date: ${newdatdd}-${newdatmon}-${newdatyr}"
    }


        override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        return when (item.itemId) {
            R.id.action_settings -> true
            else -> super.onOptionsItemSelected(item)
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        val navController = findNavController(R.id.nav_host_fragment_content_main)
        return navController.navigateUp(appBarConfiguration)
                || super.onSupportNavigateUp()
    }
}