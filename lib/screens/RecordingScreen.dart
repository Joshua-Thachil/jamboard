import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../Style/Palette.dart';
import '../components/InputFields.dart';

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

  bool flag = true;
  List<List> _recordingList = [
    ["Verse1","/storage/emulated/0/Recordings/myaudio_1729187892030.mp3",2,"Oct 17th"],
    ["Prechorus","/storage/emulated/0/Recordings/myaudio_1729188617816.mp3",10,"Oct 17th"],
  ];
  bool _isSearchActive = false;
  final TextEditingController _recordingnamecontroller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<List> _filteredRecordingList = [];

  Future<void> _showRecorder(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shadowColor: Colors.black,
          elevation: 10.0,
          backgroundColor: Color(0xff131313),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity, // Make the container take the maximum width
            padding: EdgeInsets.all(20), // Add padding if needed
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use minimum size for dialog
              children: [
                Text(
                  'Recording',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30), // Add space between title and input field
                InputField(
                  InputController: _recordingnamecontroller,
                  height: 1,
                  hint: 'Enter project title',
                ),
                SizedBox(height: 20), // Add space between input and buttons
                _buildTimer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TextButton(
                    //   child:
                    //       Text('Pause', style: TextStyle(color: Colors.white)),
                    //   onPressed: () {},
                    // ),
                    // SizedBox(width: 10), // Add space between buttons
                    TextButton(
                      child:
                          Text('Stop', style: TextStyle(color: Colors.white)),
                      onPressed: () async{
                        String path = await stopRecording();
                        String title = _recordingnamecontroller.text;
                        _recordingList.add([title, path,0,""]);
                        setState(() {
                          _filteredRecordingList = _recordingList;
                        });

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  // Function to filter the project list based on search input
  void _filterRecordings(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRecordingList = _recordingList;
      } else {
        _filteredRecordingList = _recordingList
            .where((recording) =>
                recording[0].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> startRecording() async {
    try {
      _startTimer();
      if (await audioRecorder.hasPermission()) {
        // Generate a unique file name based on timestamp
        final timeStamp = DateTime.now().millisecondsSinceEpoch;
        audioPath = '/storage/emulated/0/Recordings/myaudio_$timeStamp.mp3'; // Unique path
        print("FILE PATH: $audioPath");

        const config =
            RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1);

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

  List<String> recordedFiles = []; // List to store audio file paths

  Future<String> stopRecording() async {
    try {
      final path = await audioRecorder.stop();
      _timer?.cancel();

      if (path != null) {
        setState(() {
          audioPath = path;
          isRecording = false;
          _recordDuration = 0;
          recordedFiles.add(audioPath); // Add the file path to the list
        });
      }
    } catch (e) {
      print("Error while stopping recording: $e");
    }
    print("PATH LIST: $recordedFiles");
    return audioPath;
  }

  Future<void> playRecording(String filePath) async {
    try {
      print("PLAYING:$filePath");
      await audioPlayer.play(DeviceFileSource(filePath)); // Play specific file
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
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Align the row's children to the right
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
                                  onChanged: _filterRecordings,
                                  controller: _searchController,
                                  autofocus: true,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Search recording',
                                    hintStyle: TextStyle(color: Colors.white70),
                                    filled: true,
                                    fillColor: Palette.secondary_bg,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                )
                              : SizedBox
                                  .shrink(), // Hide search bar when inactive
                        ),
                      ),
                      // Title and subtitle animation (shown when search is inactive)
                      AnimatedOpacity(
                        opacity: _isSearchActive ? 0 : 1,
                        duration: Duration(milliseconds: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          key: const ValueKey("titleText"),
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.arrow_back)),
                            // SizedBox(width: 30),
                            Text(
                              "Project name",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 20,),
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
                        _filteredRecordingList =
                            _recordingList; // Reset to show all projects
                      }
                      // Toggle the search state
                      _isSearchActive = !_isSearchActive;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            // SAmple "Oct 18th, 8:00pm"
            Expanded(
              child: ListView.builder(
                   itemCount: _filteredRecordingList.length,
                   itemBuilder: (context, index) {
                     final String recordingtitle = _filteredRecordingList[index][0];
                     final String recordingpath = _filteredRecordingList[index][1];
                     final int recordingduration = _filteredRecordingList[index][2];
                     final String recordingdate = _filteredRecordingList[index][3];
                     return Padding(
                       padding: const EdgeInsets.only(bottom: 10.0),
                       child: Dismissible(
                         key: Key(recordingtitle), // Unique key for each project
                         background: Container(
                           color:
                               Colors.red, // Background color when swiping
                           alignment: Alignment.centerLeft,
                           padding: EdgeInsets.only(left: 20),
                           child: Icon(Icons.delete,
                               color: Colors.white), // Delete icon
                         ),
                         onDismissed: (direction) {
                           setState(() async {
                             // Remove the project from the original list
                             _recordingList.remove(recordingtitle);
                             //await Supabase.instance.client.from('Projects').delete().eq('title', project);
              
                             // Remove from the filtered list
                             _filteredRecordingList.removeAt(index);
                           });
              
                           // // Optionally, show a snackbar
                           // ScaffoldMessenger.of(context).showSnackBar(
                           //   SnackBar(content: Text("$project dismissed")),
                           // );
                         },
                         child: GestureDetector(
                           onTap: (){
                             playRecording(recordingpath);
                           },
                           child: Container(
                             width: 366,
                             height: 127,
                             clipBehavior: Clip.antiAlias,
                             decoration: BoxDecoration(
                               color: Color(0xFF1E1E1E),
                               borderRadius: BorderRadius.circular(20),
                             ),
                             child: Stack(
                               children: [
                                 // Profile Image Container
                                 Positioned(
                                   left: 19,
                                   top: 15,
                                   child: Container(
                                     width: 54,
                                     height: 54,
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(50),
                                       image: DecorationImage(
                                         image: NetworkImage(
                                             "https://via.placeholder.com/54x54"),
                                         fit: BoxFit.cover,
                                       ),
                                     ),
                                   ),
                                 ),
                                 // Title and Username
                                 Positioned(
                                   left: 83, // Adjusted for better alignment with the image
                                   top: 15,
                                   child: Column(
                                     crossAxisAlignment:
                                         CrossAxisAlignment.start,
                                     children: [
                                       Text(
                                         recordingtitle,
                                         style: TextStyle(
                                           color: Colors.white,
                                           fontSize:
                                               18, // Adjusted for better readability
                                           fontFamily: 'Josefin Sans',
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ),
                                       SizedBox(height: 8), // Reduced space
                                       // Text(
                                       //   'snoopy144',
                                       //   style: TextStyle(
                                       //     color: Colors.white,
                                       //     fontSize: 14,
                                       //     fontStyle: FontStyle.italic,
                                       //     fontFamily: 'Josefin Sans',
                                       //     fontWeight: FontWeight.w300,
                                       //   ),
                                       // ),
                                     ],
                                   ),
                                 ),
                                 // Date
                                 Positioned(
                                   left: 30,
                                   top: 70,
                                   child: Text(
                                     recordingdate,
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 12,
                                       fontStyle: FontStyle.italic,
                                     ),
                                   ),
                                 ),
                                 // Progress Bar
                                 Positioned(
                                   left: 19,
                                   top: 100,
                                   child: Container(
                                     width: 300,
                                     height: 5,
                                     decoration: BoxDecoration(
                                       color: Palette.primary,
                                       borderRadius: BorderRadius.circular(11),
                                     ),
                                     child: Align(
                                       alignment: Alignment.centerLeft,
                                       child: Container(
                                         width: 16,
                                         height: 16,
                                         decoration: BoxDecoration(
                                           color: Color(0xFFD9D9D9),
                                           shape: BoxShape.circle,
                                         ),
                                       ),
                                     ),
                                   ),
                                 ),
                                 // Time Indicator
                                 Positioned(
                                   left: 300,
                                   top: 80,
                                   child: Text(
                                     recordingduration.toString(),
                                     style: TextStyle(
                                       color: Color(0xFFC0C0C0),
                                       fontSize: 12,
                                       fontFamily: 'Josefin Sans',
                                       fontWeight: FontWeight.w400,
                                     ),
                                   ),
                                 ),
                               ],
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
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  startRecording();
                  _showRecorder(context);
                },
                child: Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 80,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

}
