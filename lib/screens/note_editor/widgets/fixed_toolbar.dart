import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/screens/note_editor/widgets/color_button.dart';
import 'package:cybersafe_pro/screens/note_editor/widgets/icon_toolbar_button.dart';
import 'package:cybersafe_pro/screens/note_editor/widgets/text_toolbar_button.dart';
import 'package:cybersafe_pro/screens/note_editor/widgets/toolbar_group.dart';
import 'package:flutter/material.dart';

class FixedToolbar extends StatelessWidget {
  const FixedToolbar({super.key, required this.editorState});

  final EditorState editorState;

  // Define color options for text and background
  static const List<Map<String, dynamic>> textColors = [
    {'name': 'Gray', 'color': Colors.grey, 'hex': '#808080'},
    {'name': 'Brown', 'color': Color(0xFFA52A2A), 'hex': '#A52A2A'},
    {'name': 'Yellow', 'color': Colors.yellow, 'hex': '#FFFF00'},
    {'name': 'Green', 'color': Colors.green, 'hex': '#00FF00'},
    {'name': 'Blue', 'color': Colors.blue, 'hex': '#0000FF'},
    {'name': 'Purple', 'color': Colors.purple, 'hex': '#800080'},
    {'name': 'Pink', 'color': Colors.pink, 'hex': '#FFC0CB'},
    {'name': 'Red', 'color': Colors.red, 'hex': '#FF0000'},
  ];

  static const int alpha = 77;

  static final List<Map<String, dynamic>> backgroundColors = [
    {'name': 'Gray', 'color': Colors.grey.withAlpha(alpha), 'hex': '#80808080'},
    {'name': 'Brown', 'color': Color(0xFFA52A2A).withAlpha(alpha), 'hex': '#80A52A2A'},
    {'name': 'Yellow', 'color': Colors.yellow.withAlpha(alpha), 'hex': '#80FFFF00'},
    {'name': 'Green', 'color': Colors.green.withAlpha(alpha), 'hex': '#8000FF00'},
    {'name': 'Blue', 'color': Colors.blue.withAlpha(alpha), 'hex': '#800000FF'},
    {'name': 'Purple', 'color': Colors.purple.withAlpha(alpha), 'hex': '#80800080'},
    {'name': 'Pink', 'color': Colors.pink.withAlpha(alpha), 'hex': '#80FFC0CB'},
    {'name': 'Red', 'color': Colors.red.withAlpha(alpha), 'hex': '#80FF0000'},
  ];

  String colorToHex(Color color) {
    return '#'
        '${color.alpha.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${color.red.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${color.green.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${color.blue.toRadixString(16).padLeft(2, '0').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: editorState.selectionNotifier,
      builder: (context, selection, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Other group (divider, checkbox, ...)
              ToolbarGroup(
                child: Row(
                  children: [
                    IconToolbarButton(
                      icon: Icons.check_box_outlined,
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            if (node.type == TodoListBlockKeys.type) {
                              return node.copyWith(
                                type: 'paragraph', // hoặc type mặc định của bạn
                                attributes: {...node.attributes}..remove(TodoListBlockKeys.checked),
                              );
                            } else {
                              // Chưa là todo, chuyển sang todo
                              return node.copyWith(
                                type: TodoListBlockKeys.type,
                                attributes: {...node.attributes, TodoListBlockKeys.checked: false},
                              );
                            }
                          }),
                    ),
                    IconToolbarButton(
                      icon: Icons.horizontal_rule,
                      onTap: () {
                        final selection = editorState.selection;
                        if (selection == null) return;
                        final transaction = editorState.transaction;
                        transaction.insertNode(selection.start.path.next, dividerNode());
                        editorState.apply(transaction);
                      },
                    ),
                  ],
                ),
              ),
              _dividerCustom(context),
              ToolbarGroup(
                child: Row(
                  children: [
                    IconToolbarButton(
                      icon: Icons.format_bold,
                      isActive: _isTextDecorationActive(
                        editorState,
                        selection,
                        AppFlowyRichTextKeys.bold,
                      ),
                      onTap: () => editorState.toggleAttribute(AppFlowyRichTextKeys.bold),
                    ),
                    IconToolbarButton(
                      icon: Icons.format_italic,
                      isActive: _isTextDecorationActive(
                        editorState,
                        selection,
                        AppFlowyRichTextKeys.italic,
                      ),
                      onTap: () => editorState.toggleAttribute(AppFlowyRichTextKeys.italic),
                    ),
                    IconToolbarButton(
                      icon: Icons.format_underlined,
                      isActive: _isTextDecorationActive(
                        editorState,
                        selection,
                        AppFlowyRichTextKeys.underline,
                      ),
                      onTap: () => editorState.toggleAttribute(AppFlowyRichTextKeys.underline),
                    ),
                    IconToolbarButton(
                      icon: Icons.format_strikethrough,
                      isActive: _isTextDecorationActive(
                        editorState,
                        selection,
                        AppFlowyRichTextKeys.strikethrough,
                      ),
                      onTap: () => editorState.toggleAttribute(AppFlowyRichTextKeys.strikethrough),
                    ),
                  ],
                ),
              ),
              _dividerCustom(context),
              // Block group
              ToolbarGroup(
                child: Row(
                  children: [
                    IconToolbarButton(
                      icon: Icons.format_quote,
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            return node.copyWith(
                              type:
                                  node.type == QuoteBlockKeys.type
                                      ? ParagraphBlockKeys.type
                                      : QuoteBlockKeys.type,
                            );
                          }),
                    ),
                    TextToolbarButton(
                      label: 'H1',
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            if (node.type == HeadingBlockKeys.type &&
                                node.attributes['level'] == 1) {
                              return node.copyWith(type: ParagraphBlockKeys.type);
                            }
                            return node.copyWith(
                              type: HeadingBlockKeys.type,
                              attributes: {...node.attributes, 'level': 1},
                            );
                          }),
                    ),
                    TextToolbarButton(
                      label: 'H2',
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            if (node.type == HeadingBlockKeys.type &&
                                node.attributes['level'] == 2) {
                              return node.copyWith(type: ParagraphBlockKeys.type);
                            }
                            return node.copyWith(
                              type: HeadingBlockKeys.type,
                              attributes: {...node.attributes, 'level': 2},
                            );
                          }),
                    ),
                    TextToolbarButton(
                      label: 'H3',
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            if (node.type == HeadingBlockKeys.type &&
                                node.attributes['level'] == 3) {
                              return node.copyWith(type: ParagraphBlockKeys.type);
                            }
                            return node.copyWith(
                              type: HeadingBlockKeys.type,
                              attributes: {...node.attributes, 'level': 3},
                            );
                          }),
                    ),
                  ],
                ),
              ),
              _dividerCustom(context),
              // Text Color group
              ToolbarGroup(
                canExpand: true,
                iconExpand: Icons.title_outlined,
                child: Row(
                  children:
                      textColors
                          .map(
                            (color) => ColorButtonCustom(
                              color: color['color'],
                              label: color['name'],
                              onTap: () {
                                final selection = editorState.selection;
                                if (selection != null && !selection.isCollapsed) {
                                  editorState.formatDelta(selection, {'font_color': color['hex']});
                                }
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
              _dividerCustom(context),
              // Background Color group
              ToolbarGroup(
                canExpand: true,
                iconExpand: Icons.font_download_outlined,
                child: Row(
                  children:
                      backgroundColors
                          .map(
                            (color) => ColorButtonCustom(
                              color: color['color'],
                              label: color['name'],
                              onTap: () {
                                final selection = editorState.selection;
                                if (selection != null && !selection.isCollapsed) {
                                  editorState.formatDelta(selection, {
                                    'bg_color': colorToHex(color['color']),
                                  });
                                }
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
              _dividerCustom(context),
              // Text Style group
              // List group
              ToolbarGroup(
                child: Row(
                  children: [
                    IconToolbarButton(
                      icon: Icons.format_list_bulleted,
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            return node.copyWith(
                              type:
                                  node.type == BulletedListBlockKeys.type
                                      ? ParagraphBlockKeys.type
                                      : BulletedListBlockKeys.type,
                            );
                          }),
                    ),
                    IconToolbarButton(
                      icon: Icons.format_list_numbered,
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            return node.copyWith(
                              type:
                                  node.type == NumberedListBlockKeys.type
                                      ? ParagraphBlockKeys.type
                                      : NumberedListBlockKeys.type,
                            );
                          }),
                    ),
                  ],
                ),
              ),
              _dividerCustom(context),
              // Align group
              ToolbarGroup(
                child: Row(
                  children: [
                    IconToolbarButton(
                      icon: Icons.format_align_left,
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            return node.copyWith(attributes: {...node.attributes, 'align': 'left'});
                          }),
                    ),
                    IconToolbarButton(
                      icon: Icons.format_align_center,
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            return node.copyWith(
                              attributes: {...node.attributes, 'align': 'center'},
                            );
                          }),
                    ),
                    IconToolbarButton(
                      icon: Icons.format_align_right,
                      onTap:
                          () => editorState.formatNode(null, (node) {
                            return node.copyWith(
                              attributes: {...node.attributes, 'align': 'right'},
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dividerCustom(BuildContext context) {
    return Container(
      color: context.darkMode ? Colors.white.withValues(alpha: 0.4) : Colors.black,

      height: 15,
      width: 1,
    );
  }

  bool _isTextDecorationActive(EditorState editorState, Selection? selection, String name) {
    selection = selection ?? editorState.selection;
    if (selection == null) {
      return false;
    }
    final nodes = editorState.getNodesInSelection(selection);
    if (selection.isCollapsed) {
      return editorState.toggledStyle.containsKey(name);
    } else {
      return nodes.allSatisfyInSelection(selection, (delta) {
        return delta.everyAttributes((attributes) => attributes[name] == true);
      });
    }
  }
}
