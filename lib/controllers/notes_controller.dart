import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:gotask/common/encryption.dart';
import 'package:gotask/models/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'login_controller.dart';

class NotesController extends GetxController {
  RxList<Note> lastNotes = RxList<Note>();
  Rx<HashSet<String>> jobs = HashSet<String>().obs;

  bool get working => jobs.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _pullFromStorage();
  }

  @override
  void onClose() {
    lastNotes.clear();
    jobs.value.clear();
    super.onClose();
  }

  static const String _listSeparator = "࠸ࠑࠇ࠷࠺";

  Future<void> _pullFromStorage() async {
    const store = FlutterSecureStorage();
    final j = await store.read(key: "notes");
    if (j == null) return;
    final jList = j.split(_listSeparator);
    try {
      final notes = jList.map<Note>((noteJ) => Note.fromJson(noteJ));
      lastNotes(notes.toList());
    } catch (e) {
      Get.dialog(
        AlertDialog(
          icon: const Icon(Icons.error_rounded),
          iconColor: Colors.red,
          title: const Text("Failed to load cached notes"),
          content: const Text("Do you want to clear cache?"),
          actions: [
            ElevatedButton(onPressed: Get.back, child: const Text("No")),
            ElevatedButton(
              onPressed: () {
                store.delete(key: 'notes');
                Get.back();
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _pushToStorage() async {
    const store = FlutterSecureStorage();
    final jsonList = lastNotes.map((note) => note.toJson());
    final String list = jsonList.join(_listSeparator);
    store.write(key: "notes", value: list);
  }

  Future<Iterable<Note>?> fetch() async {
    final jobID = const Uuid().v4();
    jobs.value.add(jobID);
    try {
      final loginController = Get.find<LoginController>();
      if (!loginController.isLoggedIn) return null;

      final session = loginController.session.value;
      if (session == null) return null;

      final userid = session.user.id;
      final accessToken = session.accessToken;

      final List<Map<String, dynamic>> res //
          = await Supabase.instance.client //
              .from("notes")
              .select()
              .eq("userid", userid);

      if (res.isEmpty) return null;

      final List<Note> notes = [];

      for (final row in res) {
        final noteEncrypted = row["noteEncrypted"] as String?;
        if (noteEncrypted == null) continue;

        try {
          final noteJson = decryptBase64(accessToken, noteEncrypted);
          final note = Note.fromJson(noteJson);
          notes.add(note);
        } catch (error) {
          _onWarning(error);
          continue;
        }
      }
      lastNotes(notes);
      await _pushToStorage();
      update();
      return notes;
    } catch (error, stack) {
      _onError(error, stackTrace: stack);
      return null;
    } finally {
      jobs.value.remove(jobID);
    }
  }

  /// @returns true if found and deleted
  Future<bool> delete(Note note) async {
    final jobID = const Uuid().v4();
    jobs.value.add(jobID);
    try {
      final loginController = Get.find<LoginController>();
      if (!loginController.isLoggedIn) return false;

      final notes = (await fetch())?.toList() ?? [];
      if (notes.isEmpty) return false;

      int noteIndex = -1;
      for (int i = 0; i < notes.length; i++) {
        final noteFromStorage = notes[i];
        if (noteFromStorage.id == note.id) {
          noteIndex = i;
          break;
        }
      }

      if (noteIndex < 0) return false;

      final session = loginController.session.value;
      if (session == null) return false;

      final userid = session.user.id;
      final accessToken = session.accessToken;

      final noteJson = note.toJson();
      final noteEncrypted = encryptToBase64(accessToken, noteJson);

      await Supabase.instance.client //
          .from("notes")
          .delete()
          .eq("userid", userid)
          .eq("noteEncrypted", noteEncrypted);
      //
      // if (res.stat != null) {
      //   _onError(res.error);
      //   return false;
      // }

      notes.removeAt(noteIndex);
      lastNotes(notes);

      await _pushToStorage();
      update();

      return true;
    } catch (error, stack) {
      _onError(error, stackTrace: stack);
      return false;
    } finally {
      jobs.value.remove(jobID);
    }
  }

  Future<bool> save(Note note) async {
    final jobID = const Uuid().v4();
    jobs.value.add(jobID);
    try {
      final loginController = Get.find<LoginController>();
      if (!loginController.isLoggedIn) return false;

      final notes = (await fetch())?.toList() ?? [];
      notes.add(note);

      final session = loginController.session.value;
      if (session == null) return false;

      final userid = session.user.id;
      final accessToken = session.accessToken;

      final noteJson = note.toJson();

      final encrypted64 = encryptToBase64(accessToken, noteJson);

      await Supabase.instance.client.from("notes").insert({
        "userid": userid,
        "noteEncrypted": encrypted64,
      });

      lastNotes(notes);

      await _pushToStorage();
      update();

      return true;
    } catch (error, stack) {
      _onError(error, stackTrace: stack);
      return false;
    } finally {
      jobs.value.remove(jobID);
    }
  }

  void _onError(Object error, {StackTrace? stackTrace}) {
    final sb = StringBuffer();
    sb.write(error.toString());
    if (stackTrace != null) {
      sb.write("\n\n > Stack trace:\n");
      sb.write(stackTrace.toString());
    }
    _onInfo("Error", sb.toString(), Icons.error_rounded);
  }

  void _onWarning(Object warning) {
    _onInfo("Warning", warning, Icons.warning_rounded);
  }

  void _onInfo(String title, Object info, IconData icon) {
    Get.dialog(AlertDialog(
      icon: Icon(icon),
      iconColor: Colors.red,
      title: Text(title),
      content: Text(info.toString()),
      actions: [
        ElevatedButton(onPressed: Get.back, child: const Text("OK")),
      ],
    ));
  }
}
