import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/modals/loading_modal.dart';
import 'package:read_quest/core/model/book_model.dart';
import 'package:read_quest/core/widgets/primary_button.dart';
import 'package:read_quest/features/home/repository/book_repository.dart';
import 'package:read_quest/features/home/views/admin/provider/addbook_provider/add_book_form_provider.dart';
import 'package:read_quest/features/home/views/admin/provider/addbook_provider/add_book_page_provider.dart';
import 'package:read_quest/features/home/views/admin/screen/dashboard/book_management/upload_book/widgets/add_book_info.dart';
import 'package:read_quest/features/home/views/admin/screen/dashboard/book_management/upload_book/widgets/add_book_summary.dart';
import 'package:read_quest/features/home/views/admin/screen/dashboard/book_management/upload_book/widgets/add_reading_book_file.dart';

class AddBookScreen extends ConsumerStatefulWidget {
  const AddBookScreen({super.key});

  @override
  ConsumerState<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends ConsumerState<AddBookScreen> {
  //

  void uploadBook(WidgetRef ref) async {
    final title = ref.read(titleFormProvider);
    final cover = ref.read(coverFormProvider);
    final description = ref.read(descriptionFormProvider);
    final file = ref.read(fileFormProvider);
    final repo = ref.read(bookRepositoryProvider);

    // print(
    //   '${title.text}, ${cover?.path}, ${description.text}, FILE: ${file?.files.first.path}',
    // );
    if (file == null) return;
    final book = BookModel(
      id: '',
      cover: cover?.path,
      title: title.text,
      description: description.text,
      file: file.files.first.path ?? '',
    );

    LoadingModal.showLoadingModal(context);
    final result = await repo.uploadBook(book);
    if (!mounted) return;
    LoadingModal.hideLoadingModal(context);
    if (result.isSuccess) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success',
        desc: 'Book uploaded successfully',
      ).show();
      if (!mounted) return;
      Navigator.pop(context);
      return;
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Failed',
        desc: result.error,
      ).show();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pageController = ref.watch(addBookPageProvider(ref));
    final pageControllerProvider = ref.read(addBookPageProvider(ref).notifier);
    final addBookButtonLabel = ref.watch(addBookButtonLabelProvider);
    final formKey = ref.watch(formKeyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Book'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: formKey,
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [AddCoverAndTitle(), AddReadingBookFile(), BookSummary()],
        ),
      ),

      bottomNavigationBar: buildNavBottom(
        size,
        pageController,
        pageControllerProvider,
        addBookButtonLabel,
      ),
    );
  }

  Widget buildNavBottom(
    Size size,
    PageController pageController,
    AddBookProvider pageControllerProvider,
    Map<String, String> addBookButtonLabelProvider,
  ) {
    return Padding(
      padding: EdgeInsets.all(size.width / 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: PrimaryButton(
              color: AppColors.textLabel,
              label: addBookButtonLabelProvider['prev']!,
              onPressed: pageControllerProvider.previousPage,
            ),
          ),
          Gap(size.width / 16),
          Expanded(
            child: PrimaryButton(
              color: AppColors.primary,
              label: addBookButtonLabelProvider['next']!,
              onPressed: () => pageControllerProvider.pageIndex == 2
                  ? uploadBook(ref)
                  : pageControllerProvider.nextPage(),
            ),
          ),
        ],
      ),
    );
  }
}
