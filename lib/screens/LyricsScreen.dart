import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:jamboard/Style/Palette.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {

  QuillController lyricsController = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(child: Padding(
            padding: EdgeInsets.only(right: 30),
            child: Text("Project Name", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          )),
          leading: IconButton(onPressed: null, icon: Icon(Icons.arrow_back, color: Colors.white,)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, top: 40, right: 15),
          child: Column(
            children: [
              Expanded(
                child: Container(child: QuillEditor.basic(
                  controller: lyricsController,
                  configurations: QuillEditorConfigurations(
                    customStyles: DefaultStyles(
                      paragraph: DefaultTextBlockStyle(TextStyle(color: Colors.white), HorizontalSpacing(5, 5), VerticalSpacing(2, 2), VerticalSpacing(1, 1), null)
                    )
                  ),
                )),
              ),
            ],
          ),
        ));
  }
}
