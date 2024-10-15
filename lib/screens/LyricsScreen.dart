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
          title: Center(
              child: Padding(
            padding: EdgeInsets.only(right: 30),
            child: Text(
              "Project Name",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, top: 40, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                    child: QuillEditor.basic(
                  controller: lyricsController,
                  configurations: QuillEditorConfigurations(
                      customStyles: DefaultStyles(
                          paragraph: DefaultTextBlockStyle(
                              TextStyle(color: Colors.white, fontSize: 18),
                              HorizontalSpacing(5, 5),
                              VerticalSpacing(2, 2),
                              VerticalSpacing(1, 1),
                              null))),
                )),
              ),
              QuillToolbar.simple(
                  controller: lyricsController,
                  configurations: QuillSimpleToolbarConfigurations(
                    dialogTheme: QuillDialogTheme(),
                    showAlignmentButtons: false,
                    showColorButton: false,
                    showFontFamily: false,
                    showDirection: false,
                    showLineHeightButton: false,
                    showSubscript: false,
                    showSuperscript: false,
                    showFontSize: false,
                    showDividers: false,
                    showSearchButton: false,
                    showIndent: false,
                    showQuote: false,
                    showInlineCode: false,
                    showHeaderStyle: false,
                    showListBullets: false,
                    showListNumbers: false,
                    showLink: false,
                    showCodeBlock: false,
                    showListCheck: false,
                    showUndo: false,
                    showRedo: false,
                    showClipboardCopy: false,
                    showClipboardCut: false,
                    showClipboardPaste: false,
                    showClearFormat: false,
                    toolbarIconCrossAlignment: WrapCrossAlignment.center,
                  ))
            ],
          ),
        ));
  }
}
