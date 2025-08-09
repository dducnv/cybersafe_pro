import 'package:cybersafe_pro/components/dialog/app_custom_dialog.dart';
import 'package:cybersafe_pro/extensions/extension_build_context.dart';
import 'package:cybersafe_pro/localization/keys/note_text.dart';
import 'package:cybersafe_pro/providers/note_provider.dart';
import 'package:cybersafe_pro/utils/scale_utils.dart';
import 'package:cybersafe_pro/widgets/text_style/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteAppbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<NoteAppbar> createState() => _NoteAppbarState();

  @override
  final Size preferredSize;

  const NoteAppbar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight);
}

class _NoteAppbarState extends State<NoteAppbar> {
  @override
  Widget build(BuildContext context) {
    return Selector<NoteProvider, int>(
      selector: (context, noteProvider) => noteProvider.selectedNotes.length,
      builder: (context, selectedNotes, child) {
        return AppBar(
          leading:
              selectedNotes > 0
                  ? IconButton(
                    onPressed: () {
                      context.read<NoteProvider>().clearSelectedNotes();
                    },
                    icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
                  )
                  : null,
          title:
              selectedNotes > 0
                  ? null
                  : Text(
                    context.trNote(NoteText.notes),
                    style: CustomTextStyle.regular(fontSize: 18.sp),
                  ),
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor:
              context.watch<NoteProvider>().selectedNotes.isNotEmpty
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
          actions: [
            selectedNotes > 0
                ? Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      showAppCustomDialog(
                        context,
                        AppCustomDialog(
                          title: context.trSafe(NoteText.deleteTitle),
                          message: context
                              .trSafe(NoteText.deleteManyConfirmation)
                              .replaceAll("[number]", selectedNotes.toString()),
                          confirmText: context.trSafe(NoteText.delete),
                          cancelText: context.trSafe(NoteText.cancelDelete),
                          confirmButtonColor: Colors.red,
                          cancelButtonColor: Theme.of(context).colorScheme.primary,
                          isCountDownTimer: false,
                          canConfirmInitially: true,
                          onConfirm: () async {
                            context.read<NoteProvider>().deleteSelectedNotes();
                          },
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, color: Colors.redAccent, size: 24.sp),
                        const SizedBox(width: 5),
                        Text(
                          selectedNotes.toString(),
                          style: CustomTextStyle.regular(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
