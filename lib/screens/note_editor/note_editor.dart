import 'dart:convert';

import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/note_text.dart';
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
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initNote();
  }

  Future<void> _initNote() async {
    final noteProvider = context.read<NoteProvider>();
    QuillController controller;
    if (widget.noteId == null) {
      _isEditing = true;
      _titleController.text = "";
      noteProvider.clearValue();
      controller = QuillController.basic(config: QuillControllerConfig());
    } else {
      final note = await noteProvider.findById(widget.noteId!);
      if (note != null) {
        _titleController.text = await noteProvider.decryptTitle(note.title);
        final content = await noteProvider.decryptContent(note.content);
        if (content.isNotEmpty) {
          controller = QuillController(document: Document.fromJson(jsonDecode(content)), selection: const TextSelection.collapsed(offset: 0));
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

  void _enableEditing() {
    if (!_isEditing) {
      setState(() {
        _isEditing = true;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _editorFocusNode.requestFocus();
      });
    }
  }

  void _saveNote() {
    if (_quillController == null) return;
    context.read<NoteProvider>().markAsDirty(title: _titleController.text, getQuillDocument: () => _quillController!.document);
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          style: theme.textTheme.titleLarge,
          readOnly: !_isEditing,
          decoration: InputDecoration(hintText: context.trNote(NoteText.title), border: InputBorder.none),
          onChanged: (_) => _saveNote(),
        ),
        actions: [
          if (!_isEditing) IconButton(icon: const Icon(Icons.edit), onPressed: _enableEditing),
          Consumer<NoteProvider>(
            builder: (context, noteProvider, child) {
              if (noteProvider.isSaving) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _quillController == null
                  ? Center(child: CircularProgressIndicator())
                  : QuillEditor(
                      controller: _quillController!,
                      focusNode: _editorFocusNode,
                      config: QuillEditorConfig(
                        autoFocus: widget.noteId == null,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        enableAlwaysIndentOnTab: true,
                        scrollBottomInset: 8,
                        minHeight: 240,
                        maxContentWidth: 800,
                        keyboardAppearance: Theme.of(context).brightness,
                        enableInteractiveSelection: true,
                        onTapUp: (event, p1) {
                          if (!_isEditing) {
                            _enableEditing();
                            return true;
                          }
                          return false;
                        },
                        onTapOutsideEnabled: true,
                        onTapOutside: (event, focusNode) {
                          focusNode.unfocus();
                        },
                        requestKeyboardFocusOnCheckListChanged: true,
                        customLinkPrefixes: const ['http', 'https', 'mailto', 'tel'],
                        onPerformAction: (action) {
                          if (_quillController == null) return;
                          // Handle common Samsung IME actions that may not send newline
                          if (action == TextInputAction.newline || action == TextInputAction.next || action == TextInputAction.go) {
                            final sel = _quillController!.selection;
                            final start = sel.start;
                            final len = sel.end - sel.start;
                            _quillController!.replaceText(start, len, '\n', TextSelection.collapsed(offset: start + 1));
                          }
                        },
                      ),
                      scrollController: ScrollController(),
                    ),
            ),
            if (_quillController != null && _isEditing)
              SafeArea(
                child: QuillSimpleToolbar(
                  controller: _quillController!,
                  config: QuillSimpleToolbarConfig(
                    multiRowsDisplay: false,
                    showAlignmentButtons: true,
                    showFontFamily: true,
                    showFontSize: true,
                    showBoldButton: true,
                    showItalicButton: true,
                    showUnderLineButton: true,
                    showStrikeThrough: true,
                    showColorButton: true,
                    showBackgroundColorButton: true,
                    showClearFormat: true,
                    showListNumbers: true,
                    showListBullets: true,
                    showListCheck: true,
                    showQuote: true,
                    showCodeBlock: true,
                    showIndent: true,
                    showUndo: true,
                    showRedo: true,
                    showSearchButton: true,
                    buttonOptions: QuillSimpleToolbarButtonOptions(
                      selectHeaderStyleDropdownButton: QuillToolbarSelectHeaderStyleDropdownButtonOptions(
                        afterButtonPressed: () {
                          _editorFocusNode.unfocus();
                        },
                      ),
                      fontSize: QuillToolbarFontSizeButtonOptions(
                        afterButtonPressed: () {
                          _editorFocusNode.unfocus();
                        },
                        labelOverflow: TextOverflow.fade,
                      ),
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
