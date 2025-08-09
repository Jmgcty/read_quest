import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/widgets/primary_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pageController = ref.watch(addBookPageProvider(ref));
    final pageControllerProvider = ref.read(addBookPageProvider(ref).notifier);
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
      ),
    );
  }

  Widget buildNavBottom(
    Size size,
    PageController pageController,
    AddBookProvider pageControllerProvider,
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
              label: 'Back',
              onPressed: pageControllerProvider.previousPage,
            ),
          ),
          Gap(size.width / 16),
          Expanded(
            child: PrimaryButton(
              color: AppColors.primary,
              label: 'Next',
              onPressed: pageControllerProvider.nextPage,
            ),
          ),
        ],
      ),
    );
  }
}
