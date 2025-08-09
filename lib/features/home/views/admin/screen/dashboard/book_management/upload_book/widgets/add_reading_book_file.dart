import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/widgets/primary_button.dart';
import 'package:read_quest/features/home/views/admin/provider/addbook_provider/add_book_form_provider.dart';

class AddReadingBookFile extends ConsumerWidget {
  const AddReadingBookFile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(fileFormProvider);
    final fileProvider = ref.read(fileFormProvider.notifier);

    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width / 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildFileCard(fileProvider),
          buildErrorMessage(context, file),
          Gap(size.width / 16),
          buildButton(file, fileProvider),
        ],
      ),
    );
  }

  Widget buildFileCard(FileFormProvider fileProvider) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.picture_as_pdf_rounded),
        title: Text(fileProvider.getFileName()),
      ),
    );
  }

  Widget buildButton(FilePickerResult? file, FileFormProvider fileProvider) {
    if (file == null) {
      return PrimaryButton(
        color: AppColors.success,
        label: 'Select File',
        onPressed: fileProvider.addFile,
      );
    }

    return PrimaryButton(
      color: AppColors.disabled,
      label: 'Remove File',
      onPressed: fileProvider.resetFile,
    );
  }

  Widget buildErrorMessage(BuildContext context, FilePickerResult? file) {
    if (file == null) {
      return Text(
        textAlign: TextAlign.justify,
        'Reading file is required. Please upload a file',
        style: Theme.of(
          context,
        ).textTheme.labelLarge!.copyWith(color: AppColors.error),
      );
    }
    return const SizedBox();
  }
}
