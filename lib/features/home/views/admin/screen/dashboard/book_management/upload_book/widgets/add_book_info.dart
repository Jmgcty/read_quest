import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/features/home/views/admin/provider/addbook_provider/add_book_form_provider.dart';

class AddCoverAndTitle extends ConsumerWidget {
  const AddCoverAndTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cover = ref.watch(coverFormProvider);
    final coverProvider = ref.read(coverFormProvider.notifier);
    //
    final title = ref.watch(titleFormProvider);
    final titleProvider = ref.read(titleFormProvider.notifier);

    //
    final description = ref.watch(descriptionFormProvider);
    final descriptionProvider = ref.read(descriptionFormProvider.notifier);
    //
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(size.width / 16),
        child: Column(
          children: [
            buildCover(size, cover, coverProvider),
            Gap(size.height / 30),
            buildTitle(title, titleProvider),
            Gap(size.height / 60),
            buildDescription(description, descriptionProvider),
          ],
        ),
      ),
    );
  }

  GestureDetector buildCover(
    Size size,
    XFile? coverProvider,
    CoverFormProvider coverProviderProvider,
  ) {
    return GestureDetector(
      onTap: coverProviderProvider.setCover,
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

  TextFormField buildTitle(
    TextEditingController titleController,
    TitleFormProvider titleFormProvider,
  ) {
    return TextFormField(
      controller: titleController,
      decoration: const InputDecoration(label: Text('Title')),
      validator: titleFormProvider.titleValidator,
    );
  }

  TextFormField buildDescription(
    TextEditingController descriptionController,
    DescriptionFormProvider descriptionFormProvider,
  ) {
    return TextFormField(
      maxLines: 5,
      controller: descriptionController,
      decoration: const InputDecoration(label: Text('Description')),
      validator: descriptionFormProvider.descriptionValidator,
    );
  }
}
