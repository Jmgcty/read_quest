import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class FormKeyProvider extends StateNotifier<GlobalKey<FormState>> {
  FormKeyProvider() : super(GlobalKey<FormState>());

  bool isValid() => state.currentState?.validate() ?? false;

  void reset() {
    state.currentState?.reset();
  }
}

final formKeyProvider =
    StateNotifierProvider.autoDispose<FormKeyProvider, GlobalKey<FormState>>(
      (ref) => FormKeyProvider(),
    );

class CoverFormProvider extends StateNotifier<XFile?> {
  CoverFormProvider() : super(null);

  void setCover() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    state = picked;
  }

  void resetCover() {
    state = null;
  }

  File getCover() => File(state!.path);

  bool isValidCover() => state == null;
}

final coverFormProvider =
    StateNotifierProvider.autoDispose<CoverFormProvider, XFile?>(
      (ref) => CoverFormProvider(),
    );

// =================== title
class TitleFormProvider extends StateNotifier<TextEditingController> {
  TitleFormProvider() : super(TextEditingController());

  void reset() {
    state.dispose();
    state = TextEditingController();
  }

  String? titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }
}

final titleFormProvider =
    StateNotifierProvider.autoDispose<TitleFormProvider, TextEditingController>(
      (ref) => TitleFormProvider(),
    );

// =================== description

class DescriptionFormProvider extends StateNotifier<TextEditingController> {
  DescriptionFormProvider() : super(TextEditingController());

  void reset() {
    state.dispose();
    state = TextEditingController();
  }

  String? descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    return null;
  }
}

final descriptionFormProvider =
    StateNotifierProvider.autoDispose<
      DescriptionFormProvider,
      TextEditingController
    >((ref) => DescriptionFormProvider());

// =================== file

class FileFormProvider extends StateNotifier<FilePickerResult?> {
  FileFormProvider() : super(null);

  String getFileName() => state?.files.first.name ?? 'No File Chosen';

  void addFile() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (picked != null) state = picked;
  }

  void resetFile() {
    state = null;
  }
}

final fileFormProvider =
    StateNotifierProvider<FileFormProvider, FilePickerResult?>(
      (ref) => FileFormProvider(),
    );
