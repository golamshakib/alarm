import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';

class AudioTest extends StatefulWidget {
  const AudioTest({super.key});

  @override
  State<AudioTest> createState() => _AudioTestState();
}

class _AudioTestState extends State<AudioTest> {
  final AudioRecorder audioRecorder = AudioRecorder();
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _recordingButton(),
    );
  }

  Widget _recordingButton() {
    return FloatingActionButton(
      onPressed: () async {
        if(isRecording){

        } else {
          if(await audioRecorder.hasPermission()) {
            final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
            final String filePath = p.join(appDocumentsDir.path, 'recording.wav');
              await audioRecorder.start(const RecordConfig(), path: filePath);
              setState(() {

                isRecording = true;
              });
          }
        }

      },
      child: Icon(
          isRecording ? Icons.stop :  Icons.mic),
    );
  }
}
