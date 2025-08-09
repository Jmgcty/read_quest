import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/features/home/views/admin/provider/addbook_provider/add_book_form_provider.dart';

class BookSummary extends ConsumerWidget {
  const BookSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(size.width / 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCover(
              size,
              ref.watch(coverFormProvider),
              ref.read(coverFormProvider.notifier),
            ),
            Gap(size.height / 40),
            buildTitle(ref.read(titleFormProvider)),
            Gap(size.height / 60),
            buildDescription(ref.read(descriptionFormProvider)),
            Gap(size.height / 40),
            Text('Selected File: '),
            buildFileCard(ref.read(fileFormProvider.notifier)),
          ],
        ),
      ),
    );
  }

  Widget buildCover(
    Size size,
    XFile? coverProvider,
    CoverFormProvider coverProviderProvider,
  ) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: size.height / 3,
        width: size.width / 2,
        decoration: BoxDecoration(
          color: AppColors.disabled,
          borderRadius: BorderRadius.circular(AppBorderSettings.borderRadius),
          border: Border.all(color: AppColors.grey),
        ),
        child: coverProvider != null
            ? Image.file(coverProviderProvider.getCover(), fit: BoxFit.cover)
            : Align(
                alignment: Alignment.center,
                child: const Icon(Icons.add_a_photo),
              ),
      ),
    );
  }

  TextFormField buildTitle(TextEditingController titleController) {
    return TextFormField(
      readOnly: true,
      controller: titleController,
      decoration: const InputDecoration(label: Text('Title')),
    );
  }

  TextFormField buildDescription(TextEditingController descriptionController) {
    return TextFormField(
      readOnly: true,
      maxLines: 5,
      controller: descriptionController,
      decoration: const InputDecoration(label: Text('Description')),
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
}
