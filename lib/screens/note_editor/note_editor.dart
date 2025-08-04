import 'dart:async';
import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/providers/note_provider.dart';
import 'package:cybersafe_pro/screens/note_editor/widgets/fixed_toolbar.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteEditor extends StatefulWidget {
  final int? noteId;
  const NoteEditor({super.key, this.noteId});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late final Future<EditorState> editorState;
  bool showTitleInputEdit = false;
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  StreamSubscription? _editorSubscription;

  @override
  void initState() {
    super.initState();
    editorState = _initEditorState();

    editorState.then((state) {
      _editorSubscription = state.transactionStream.listen((event) {
        final content = jsonEncode(state.document.toJson());
        context.read<NoteProvider>().onContentChanged(title: textEditingController.text, content: content);
      });
    });
  }

  Future<EditorState> _initEditorState() async {
    final noteProvider = context.read<NoteProvider>();

    if (widget.noteId == null) {
      textEditingController.text = "";
      noteProvider.clearValue();

      // Provide a default document with one paragraph node
      return EditorState.blank();
    } else {
      final note = await noteProvider.findById(widget.noteId!);
      if (note != null) {
        final title = await noteProvider.decryptTitle(note.title);
        final content = await noteProvider.decryptContent(note.content);
        textEditingController.text = title;
        if (content.isNotEmpty) {
          return EditorState(document: Document.fromJson(jsonDecode(content)));
        }
      }
      textEditingController.text = "";
      return EditorState.blank();
    }
  }

  void handleShowInputEditTitle() {
    setState(() {
      showTitleInputEdit = !showTitleInputEdit;
      if (showTitleInputEdit) {
        focusNode.requestFocus();
      } else {
        focusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    textEditingController.dispose();
    _editorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: handleShowInputEditTitle,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: showTitleInputEdit ? 0 : 1,
            child: Text(textEditingController.text.isNotEmpty ? textEditingController.text : "Tiêu đề"),
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading:
            showTitleInputEdit
                ? IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: () {
                    handleShowInputEditTitle();
                  },
                )
                : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SafeArea(
        child: FutureBuilder<EditorState>(
          future: editorState,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final editor = snapshot.data!;

            return Column(
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: showTitleInputEdit ? const BoxConstraints(minHeight: 50) : const BoxConstraints(maxHeight: 0),
                    child: AnimatedOpacity(
                      opacity: showTitleInputEdit ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  focusNode: focusNode,
                                  autofocus: showTitleInputEdit,
                                  controller: textEditingController,
                                  style: CustomTextStyle.regular(fontSize: 24, fontWeight: FontWeight.w500),
                                  onSubmitted: (value) {
                                    handleShowInputEditTitle();
                                    final noteProvider = context.read<NoteProvider>();
                                    noteProvider.onContentChanged(title: textEditingController.text, content: jsonEncode(snapshot.data!.document.toJson()));
                                  },
                                  decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: AppFlowyEditor(
                    editorState: editor,
                    editorStyle:
                        context.darkMode
                            ? EditorStyle.mobile().copyWith(
                              dragHandleColor: Theme.of(context).colorScheme.outline,
                              selectionColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              textStyleConfiguration: const TextStyleConfiguration(),
                              cursorColor: Theme.of(context).colorScheme.primary,
                            )
                            : EditorStyle.mobile().copyWith(
                              cursorColor: Theme.of(context).colorScheme.primary,
                            ),
                  ),
                ),

                SizedBox(height: 50.w, child: FixedToolbar(editorState: editor)),
              ],
            );
          },
        ),
      ),
    );
  }
}
