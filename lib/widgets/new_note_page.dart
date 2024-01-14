import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotask/common/widgets/loading_button.dart';
import 'package:gotask/controllers/login_controller.dart';
import 'package:gotask/controllers/notes_controller.dart';
import 'package:gotask/models/note.dart';
import 'package:gotask/values/predefined_padding.dart';
import 'package:gotask/values/predefined_radius.dart';
import 'package:gotask/widgets/components/common/common_appbar.dart';
import 'package:gotask/widgets/critical_error_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({super.key});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  String title = "";
  String content = "";
  bool isLoading = false;

  bool get isLocked => isLoading || title.isEmpty || content.isEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final loginController = Get.find<LoginController>();
    if (loginController.event.value != AuthChangeEvent.signedIn) {
      return const CriticalErrorPage(error: "Can't view notes. Not logged in");
    }
    final uid = loginController.session.value!.user.id;

    return Scaffold(
      appBar: const CommonAppBar(title: "New Note"),
      body: Padding(
        padding: const EdgeInsets.all(PredefinedPadding.medium),
        child: Column(
          children: [
            TextField(
              maxLines: null,
              maxLength: 5000,
              onChanged: (value) => setState(() => title = value),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(PredefinedRadius.medium),
                  borderSide: BorderSide(color: theme.colorScheme.surfaceVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(PredefinedRadius.medium),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                labelText: "Title",
                prefixIcon: const Icon(Icons.title_rounded),
              ),
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                maxLength: 5000,
                onChanged: (value) => setState(() => content = value),
                decoration: InputDecoration(
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(PredefinedRadius.medium),
                    borderSide: BorderSide(color: theme.colorScheme.surfaceVariant),
                  ),
                  labelText: "Content",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: Get.back,
                  child: const Text("Discard"),
                ),
                LoadingButton(
                  "Save",
                  onPressed: save,
                  isLocked: isLocked,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget error(String error) {
    return Center(
      child: Column(
        children: [
          Text(error),
          ElevatedButton.icon(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Reload"),
          )
        ],
      ),
    );
  }

  Future<bool> save() async {
    if (isLocked) return false;
    setState(() => isLoading = true);
    final note = Note(
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    final notesController = Get.find<NotesController>();
    final saved = await notesController.save(note);
    setState(() => isLoading = false);
    if (saved) Get.back();
    return saved;
  }
}
