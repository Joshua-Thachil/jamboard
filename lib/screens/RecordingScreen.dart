import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  late AudioRecorder audioRecorder;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';
  int _recordDuration = 0;
  Timer? _timer;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<RecordState>? _recordSub;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecorder = AudioRecorder();

    // Listen to state changes
    _recordSub = audioRecorder.onStateChanged().listen((recordState) {
      _updateRecordState(recordState);
    });

    // Listen to amplitude changes (for visual feedback)
    _amplitudeSub = audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      setState(() => _amplitude = amp);
    });

    super.initState();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        audioPath = '${directory.path}/myaudio.mp3'; // Valid path

        const config = RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1);

        await audioRecorder.start(config, path: audioPath);

        _recordDuration = 0; // Reset duration
        _startTimer();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print("Error while recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await audioRecorder.stop();
      _timer?.cancel();

      if (path != null) {
        setState(() {
          audioPath = path;
          isRecording = false;
          _recordDuration = 0;
        });
      }
    } catch (e) {
      print("Error while stopping recording: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      await audioPlayer.play(DeviceFileSource(audioPath));
    } catch (e) {
      print("Error playing: $e");
    }
  }

  void _updateRecordState(RecordState recordState) {
    setState(() => _recordState = recordState);

    if (recordState == RecordState.record) {
      _startTimer();
    } else {
      _timer?.cancel();
      _recordDuration = 0;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    audioRecorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recording Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_recordState == RecordState.record)
            const Text(
              "Recording...",
              style: TextStyle(fontSize: 24),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _recordState != RecordState.stop ? stopRecording : startRecording,
            child: Text(_recordState != RecordState.stop ? "Stop" : "Record"),
          ),
          const SizedBox(height: 20),
          if (_recordState == RecordState.stop && audioPath.isNotEmpty)
            ElevatedButton(
              onPressed: playRecording,
              child: const Text("Play"),
            ),
          const SizedBox(height: 40),
          if (_amplitude != null)
            Column(
              children: [
                Text('Current amplitude: ${_amplitude?.current ?? 0.0}'),
                Text('Max amplitude: ${_amplitude?.max ?? 0.0}'),
              ],
            ),
          const SizedBox(height: 20),
          if (_recordState != RecordState.stop) _buildTimer(),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes:$seconds',
      style: const TextStyle(color: Colors.red, fontSize: 24),
    );
  }

  String _formatNumber(int number) {
    return number < 10 ? '0$number' : number.toString();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}
