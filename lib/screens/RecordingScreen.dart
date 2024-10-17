import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../Style/Palette.dart';

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


  bool flag = false;
  List<String> _projectList = [
    "Indian OC 1",
    "Faint",
    "Strawberry pulp - version 1"
  ];
  bool _isSearchActive = false;
  final TextEditingController _projectnamecontroller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredProjectList = [];


  // Function to filter the project list based on search input
  void _filterProjects(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProjectList = _projectList;
      } else {
        _filteredProjectList = _projectList
            .where((project) => project.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        audioPath = '${directory.path}/myaudio.mp3'; // Valid path
        print("FILE PATH: $audioPath");

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
      backgroundColor: Palette.bg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            // Animated Title and Search Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align the row's children to the right
              children: [
                // Conditionally display either title or search bar based on search activity
                Expanded(
                  child: Stack(
                    // alignment: Alignment.centerRight, // Align the search bar to the right
                    children: [
                      // Search bar animation (grows from right to left)
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: _isSearchActive
                              ? MediaQuery.of(context).size.width - 90
                              : 0, // Starts at 0 width and expands
                          child: _isSearchActive
                              ? TextField(
                            onChanged: _filterProjects,
                            controller: _searchController,
                            autofocus: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search project',
                              hintStyle: TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Palette.secondary_bg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )
                              : SizedBox.shrink(), // Hide search bar when inactive
                        ),
                      ),
                      // Title and subtitle animation (shown when search is inactive)
                      AnimatedOpacity(
                        opacity: _isSearchActive ? 0 : 1,
                        duration: Duration(milliseconds: 100),
                        child: Column(
                          key: ValueKey("titleText"),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello Arlene !",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            const Text(
                              "What are we working on today?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Search/close icon
                IconButton(
                  icon: Icon(
                    _isSearchActive ? Icons.close : Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isSearchActive) {
                        // Clear the search controller
                        _searchController.clear();
                        // Reset the filtered project list
                        _filteredProjectList = _projectList; // Reset to show all projects
                      }
                      // Toggle the search state
                      _isSearchActive = !_isSearchActive;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            Expanded(
              child: flag
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/images/rb_2150544943.png', // Path to your no projects image
                    //   width: 200, // Set width for the image
                    //   height: 200, // Set height for the image
                    // ),
                    SizedBox(height: 20), // Space between image and text
                    Text(
                      'Wanna add a new project?', // Message when no projects
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _filteredProjectList.length,
                itemBuilder: (context, index) {
                  final project = _filteredProjectList[index];

                  return Dismissible(
                    key: Key(project), // Unique key for each project
                    background: Container(
                      color: Colors.red, // Background color when swiping
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(Icons.delete, color: Colors.white), // Delete icon
                    ),
                    onDismissed: (direction) {
                      setState(() async {
                        // Remove the project from the original list
                        _projectList.remove(project);
                        //await Supabase.instance.client.from('Projects').delete().eq('title', project);

                        // Remove from the filtered list
                        _filteredProjectList.removeAt(index);
                      });

                      // // Optionally, show a snackbar
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text("$project dismissed")),
                      // );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 12),
                      child: TextButton.icon(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 25)),
                          backgroundColor: WidgetStateProperty.all(Palette.secondary_bg),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () {
                          // Define your onPressed action here
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => LyricsScreen()));
                        },
                        icon: Icon(
                          Icons.music_note_outlined,
                          color: Palette.primary,
                          size: 35,
                        ),
                        label: Text(
                          project,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 40),
        child: BottomAppBar(
          color: Palette.bg,
          child: Center(
              child: GestureDetector(
                onTap: () {
                  _showInputDialog(context);
                },
                child: Icon(
                  Icons.add_circle_rounded,
                  color: Palette.primary,
                  size: 80,
                ),
              )
          ),
        ),
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
