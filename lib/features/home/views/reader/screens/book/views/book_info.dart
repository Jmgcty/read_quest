import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/handler/appwrite_file_handler.dart';
import 'package:read_quest/core/model/book_model.dart';
import 'package:read_quest/features/home/views/reader/screens/book/provider/book_info_screen_provider.dart';
import 'package:read_quest/features/home/views/reader/screens/book/views/reading_book_view.dart';

class BookInfo extends ConsumerStatefulWidget {
  const BookInfo({required this.book, super.key});
  final BookModel book;

  @override
  ConsumerState<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends ConsumerState<BookInfo> {
  void openBook() async {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => PdfViewerWithPageTracking(book: widget.book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookMode = ref.watch(changeBookModeProvider);
    final bookModeProvider = ref.read(changeBookModeProvider.notifier);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.black,
        centerTitle: true,
        title: DropdownButton(
          dropdownColor: AppColors.backgroundWhite,
          icon: const Icon(Icons.arrow_drop_down_circle),
          value: bookMode,
          items: [
            DropdownMenuItem(
              value: BookMode.book,
              child: Text(
                'Reading Mode',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: size.width / 20,
                ),
              ),
            ),
            DropdownMenuItem(
              value: BookMode.game,
              child: Text(
                'Game Mode',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: size.width / 20,
                ),
              ),
            ),
          ],
          onChanged: (BookMode? mode) {
            if (mode != null) {
              bookModeProvider.changeMode(mode);
            }
          },
        ),
      ),
      body: bookMode == BookMode.book
          ? ReadingBookInfo(book: widget.book)
          : ReadingBookGames(book: widget.book),

      bottomNavigationBar: bookMode == BookMode.game
          ? null
          : BottomAppBar(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width / 18,
                  vertical: size.height / 70,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(
                    AppBorderSettings.borderRadius,
                  ), // rounded corners
                ),
                child: InkWell(
                  onTap: openBook,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow_rounded),
                      const SizedBox(width: 8), // space between icon and text
                      Text(
                        'Read',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

//TODO  ReadingBookInfo: SHOW PDF CONTENT WHEN CLICK READ
class ReadingBookInfo extends ConsumerStatefulWidget {
  const ReadingBookInfo({required this.book, super.key});
  final BookModel book;

  @override
  ConsumerState<ReadingBookInfo> createState() => _ReadingBookInfoState();
}

class _ReadingBookInfoState extends ConsumerState<ReadingBookInfo> {
  @override
  Widget build(BuildContext context) {
    final image = ref.watch(appwriteImageProvider(widget.book.cover)).value;
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        color: AppColors.backgroundBlue,
        padding: EdgeInsets.only(
          left: size.width / 18,
          right: size.width / 18,
          top: size.height / 6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: size.width / 2.5,
                height: size.height / 3.5,
                color: AppColors.disabled,
                child: image != null
                    ? Image.memory(image, fit: BoxFit.cover)
                    : Icon(Icons.book, color: AppColors.white),
              ),
            ),

            Gap(size.height / 30),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                widget.book.title,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),
            Text(
              widget.book.description ?? 'No description',
              textAlign: TextAlign.justify,
              softWrap: true,
              overflow: TextOverflow.clip,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO ReadingBookGames: SHOW LIST OF GAMES
class ReadingBookGames extends ConsumerStatefulWidget {
  const ReadingBookGames({required this.book, super.key});
  final BookModel book;

  @override
  ConsumerState<ReadingBookGames> createState() => _ReadingBookGamesState();
}

class _ReadingBookGamesState extends ConsumerState<ReadingBookGames> {
  @override
  Widget build(BuildContext context) {
    final image = ref.watch(appwriteImageProvider(widget.book.cover)).value;
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        color: AppColors.secondaryBackground,
        padding: EdgeInsets.only(
          left: size.width / 18,
          right: size.width / 18,
          top: size.height / 6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: size.width / 2.5,
                height: size.height / 3.5,
                color: AppColors.disabled,
                child: image != null
                    ? Image.memory(image, fit: BoxFit.cover)
                    : Icon(Icons.book, color: AppColors.white),
              ),
            ),

            Gap(size.height / 30),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                widget.book.title,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),

            Gap(size.height / 40),
            Card(
              color: AppColors.success,
              child: ListTile(
                leading: Icon(Icons.quiz_rounded, color: AppColors.white),
                title: Text(
                  'Quiz Games',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: AppColors.white),
                ),
                onTap: () {},
              ),
            ),

            Card(
              color: AppColors.success,
              child: ListTile(
                leading: Icon(
                  Icons.spatial_tracking_outlined,
                  color: AppColors.white,
                ),
                title: Text(
                  'Reading Comprehension Game',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: AppColors.white),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
