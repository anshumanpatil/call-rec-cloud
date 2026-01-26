package com.phoenix.callrecordingutil.ui.home

import android.content.Context
import android.os.Bundle
import android.os.Environment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.phoenix.callrecordingutil.databinding.FragmentHomeBinding
import com.phoenix.callrecordingutil.helper.CallLogger
import com.phoenix.callrecordingutil.helper.InternalValues
import java.io.File

class HomeFragment : Fragment() {

    private var _binding: FragmentHomeBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        val homeViewModel =
            ViewModelProvider(this).get(HomeViewModel::class.java)
        val arrayAdapter: ArrayAdapter<*>
        val context: Context = requireContext().applicationContext
        val folderRecordings = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_RECORDINGS)

        InternalValues.recordingsFolder = File(folderRecordings.absolutePath, "/Call")

        CallLogger.sendLog("Path : ${InternalValues.recordingsFolder.absolutePath}")
        val files: Array<File>? = InternalValues.recordingsFolder.listFiles()
        val filenamesToShow: MutableList<String> = InternalValues.setFileNames(files)

        _binding = FragmentHomeBinding.inflate(inflater, container, false)
        val root: View = binding.root

        val listView: ListView = binding.recordingList

        arrayAdapter = ArrayAdapter(context, android.R.layout.simple_list_item_1, filenamesToShow)

        homeViewModel.text.observe(viewLifecycleOwner) {
            listView.adapter = arrayAdapter
        }
        return root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}