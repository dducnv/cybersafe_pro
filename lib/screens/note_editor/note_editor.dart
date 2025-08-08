import 'dart:convert';

import 'package:cybersafe_pro/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

class NoteEditor extends StatefulWidget {
  final int? noteId;
  const NoteEditor({super.key, this.noteId});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  QuillController? _quillController;
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _editorFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initNote();
  }

  Future<void> _initNote() async {
    final noteProvider = context.read<NoteProvider>();
    QuillController controller;
    if (widget.noteId == null) {
      _titleController.text = "";
      noteProvider.clearValue();
      controller = QuillController.basic(config: QuillControllerConfig());
    } else {
      final note = await noteProvider.findById(widget.noteId!);
      if (note != null) {
        _titleController.text = await noteProvider.decryptTitle(note.title);
        final content = await noteProvider.decryptContent(note.content);
        if (content.isNotEmpty) {
          controller = QuillController(
            document: Document.fromJson(jsonDecode(content)),
            selection: const TextSelection.collapsed(offset: 0),
          );
        } else {
          controller = QuillController.basic();
        }
      } else {
        _titleController.text = "";
        controller = QuillController.basic();
      }
    }
    controller.addListener(_saveNote);
    setState(() {
      _quillController = controller;
    });
  }

  void _saveNote() {
    if (_quillController == null) return;
    context.read<NoteProvider>().onContentChanged(
      title: _titleController.text,
      content: jsonEncode(_quillController!.document.toDelta().toJson()),
    );
  }

  @override
  void dispose() {
    _quillController?.dispose();
    _titleController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          style: theme.textTheme.titleLarge,
          decoration: const InputDecoration(hintText: "Tiêu đề", border: InputBorder.none),
          onChanged: (_) => _saveNote(),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child:
                  _quillController == null
                      ? Center(child: CircularProgressIndicator())
                      : QuillEditor(
                        controller: _quillController!,
                        focusNode: _editorFocusNode,
                        config: QuillEditorConfig(
                          autoFocus: widget.noteId == null,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        scrollController: ScrollController(),
                      ),
            ),
            if (_quillController != null)
              QuillSimpleToolbar(
                controller: _quillController!,
                config: QuillSimpleToolbarConfig(
                  multiRowsDisplay: false,
                  showAlignmentButtons: true,
                  buttonOptions: QuillSimpleToolbarButtonOptions(
                    fontSize: QuillToolbarFontSizeButtonOptions(
                      afterButtonPressed: () {
                        _editorFocusNode.unfocus();
                      },
                      labelOverflow: TextOverflow.fade,
                    ),
                    linkStyle: QuillToolbarLinkStyleButtonOptions(
                      validateLink: (link) {
                        // Treats all links as valid. When launching the URL,
                        // `https://` is prefixed if the link is incomplete (e.g., `google.com` → `https://google.com`)
                        // however this happens only within the editor.
                        return true;
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
