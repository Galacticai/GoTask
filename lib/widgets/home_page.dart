import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gotask/controllers/notes_controller.dart';
import 'package:gotask/models/note.dart';
import 'package:gotask/values/predefined_animation_duration.dart';
import 'package:gotask/values/predefined_padding.dart';
import 'package:gotask/widgets/new_note_page.dart';
import 'package:gotask/widgets/profile_page.dart';

import 'components/common/common_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isLoading) {
      return Stack(children: [
        const Center(child: LinearProgressIndicator()),
        contentView(theme),
      ]);
    }
    return contentView(theme);
  }

  @override
  void initState() {
    super.initState();
    Get.find<NotesController>().fetch();
  }

  Widget contentView(ThemeData theme) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "My Notes",
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(PredefinedPadding.medium),
              child: LinearProgressIndicator(),
            ),
          IconButton(
            onPressed: () => Get.to(() => const ProfilePage()),
            icon: const Icon(Icons.person_rounded),
          ),
        ],
      ),
      body: GetBuilder<NotesController>(
        builder: (NotesController control) {
          return AnimatedCrossFade(
            crossFadeState: control.working ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: PredefinedAnimationDuration.regular,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LinearProgressIndicator(),
                notesListView(control.lastNotes),
                //
                const SizedBox(height: PredefinedPadding.large),
                Text("DEBUG:", style: theme.textTheme.titleMedium),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: control.jobs.value.length,
                  itemBuilder: (_, int i) {
                    return Text("Job ${control.jobs.value.elementAt(i)}");
                  },
                ),
              ],
            ),
            secondChild: notesListView(control.lastNotes),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => const NewNotePage());
          setState(() {});
        },
        child: const Icon(Icons.add_rounded, size: 32),
      ),
    );
  }

  Widget errorView(String error, {bool showReload = false}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(error),
          if (showReload) const SizedBox(height: PredefinedPadding.medium),
          if (showReload)
            ElevatedButton.icon(
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Reload"),
            )
        ],
      ),
    );
  }

  Widget notesListView(List<Note> notes) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notes.length,
      itemBuilder: (_, i) => noteView(notes[i]),
    );
  }

  Widget noteView(Note note) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text("Created at: ${note.createdAt.toLocal()}"),
      onTap: () {
        Get.dialog(
          AlertDialog(
            title: Text(note.title),
            content: Text(note.content),
            actions: [
              TextButton(
                onPressed: () {
                  Get.find<NotesController>().delete(note);
                  Get.back();
                },
                child: const Text("Delete"),
              ),
              ElevatedButton(onPressed: Get.back, child: const Text("Close")),
            ],
          ),
        );
      },
    );
  }
}
