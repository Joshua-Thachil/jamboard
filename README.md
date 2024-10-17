# jamboard

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Recording module methods:



//dependencies
dependencies:
flutter_sound: ^9.0.0
path_provider: ^2.0.0
supabase_flutter: ^1.0.0
permission_handler: ^10.0.0 # To request permission to record



//supabase initialization
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Supabase.initialize(
url: 'https://your-project-url.supabase.co', // Your Supabase project URL
anonKey: 'your-anon-key', // Your Supabase anon key
);
runApp(MyApp());
}



//methods

Future<void> startRecording() async {
// Get the app directory for storing temporary audio files
Directory appDocDir = await getApplicationDocumentsDirectory();
String filePath = '${appDocDir.path}/recording-${DateTime.now().millisecondsSinceEpoch}.aac';

// Start recording and save the file locally
await _recorder.openRecorder();
await _recorder.startRecorder(toFile: filePath);
print('Recording started...');
}

Future<String?> stopRecordingAndUpload() async {
try {
// Stop the recorder
String? localFilePath = await _recorder.stopRecorder();
await _recorder.closeRecorder();
print('Recording stopped: $localFilePath');

    if (localFilePath != null) {
      // Get the file and upload to Supabase storage
      File audioFile = File(localFilePath);
      String fileName = 'audio_recordings/recording-${DateTime.now().millisecondsSinceEpoch}.aac';

      // Upload the file to Supabase Storage
      final response = await supabase.storage
          .from('audio-recordings') // Use your Supabase storage bucket name
          .upload(fileName, audioFile);

      if (response.error == null) {
        print('File uploaded successfully: ${response.data}');
        return fileName; // Return the uploaded file's path
      } else {
        print('Error uploading file: ${response.error?.message}');
        return null;
      }
    }
} catch (e) {
print('Error during recording or uploading: $e');
return null;
}
return null;
}


Recording module methods:



//dependencies
dependencies:
flutter_sound: ^9.0.0
path_provider: ^2.0.0
supabase_flutter: ^1.0.0
permission_handler: ^10.0.0 # To request permission to record



//supabase initialization
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Supabase.initialize(
url: 'https://your-project-url.supabase.co', // Your Supabase project URL
anonKey: 'your-anon-key', // Your Supabase anon key
);
runApp(MyApp());
}



//methods
FlutterSoundRecorder _recorder = FlutterSoundRecorder();
final supabase = Supabase.instance.client;

Future<void> startRecording() async {
// Request permission to record
await requestMicrophonePermission();

// Get the app directory for storing temporary audio files
Directory appDocDir = await getApplicationDocumentsDirectory();
String filePath = '${appDocDir.path}/recording-${DateTime.now().millisecondsSinceEpoch}.aac';

// Start recording and save the file locally
await _recorder.openRecorder();
await _recorder.startRecorder(toFile: filePath);
print('Recording started...');
}

Future<String?> stopRecordingAndUpload() async {
try {
// Stop the recorder
String? localFilePath = await _recorder.stopRecorder();
await _recorder.closeRecorder();
print('Recording stopped: $localFilePath');

    if (localFilePath != null) {
      // Get the file and upload to Supabase storage
      File audioFile = File(localFilePath);
      String fileName = 'audio_recordings/recording-${DateTime.now().millisecondsSinceEpoch}.aac';

      // Upload the file to Supabase Storage
      final response = await supabase.storage
          .from('audio-recordings') // Use your Supabase storage bucket name
          .upload(fileName, audioFile);

      if (response.error == null) {
        print('File uploaded successfully: ${response.data}');
        return fileName; // Return the uploaded file's path
      } else {
        print('Error uploading file: ${response.error?.message}');
        return null;
      }
    }
} catch (e) {
print('Error during recording or uploading: $e');
return null;
}
return null;
}
