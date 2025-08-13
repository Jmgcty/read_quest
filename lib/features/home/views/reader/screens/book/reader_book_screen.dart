import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/handler/appwrite_file_handler.dart';
import 'package:read_quest/core/model/book_model.dart';
import 'package:read_quest/features/home/provider/get_books.dart';
import 'package:read_quest/features/home/views/reader/screens/book/views/book_info.dart';

class ReaderBookScreen extends StatelessWidget {
  const ReaderBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Padding(
          padding: EdgeInsets.all(size.width / 24),
          child: Column(
            children: [const SearchField(), Gap(size.height / 40), BookList()],
          ),
        ),
      ),
    );
  }
}

class BookList extends ConsumerStatefulWidget {
  const BookList({super.key});

  @override
  ConsumerState<BookList> createState() => _BookListState();
}

class _BookListState extends ConsumerState<BookList> {
  @override
  Widget build(BuildContext context) {
    final books = ref.watch(getBooksProvider).value ?? [];

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2 / 3,
        ),
        itemBuilder: (context, index) => CardItem(
          book: books[index],
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (_) => BookInfo(book: books[index])),
            );
          },
        ),
        itemCount: books.length,
      ),
    );
  }
}

class CardItem extends ConsumerWidget {
  const CardItem({super.key, required this.book, this.onTap});
  final BookModel book;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(appwriteImageProvider(book.cover)).value;
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: AppColors.disabled,
            child: image != null
                ? Image.memory(image, fit: BoxFit.cover)
                : Icon(Icons.book, color: AppColors.white),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          Positioned(
            left: 6,
            bottom: 6,
            child: Text(
              book.title,
              style: theme.textTheme.headlineSmall!.copyWith(
                fontSize: size.width / 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),

          Positioned(
            top: 6,
            left: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                color: AppColors.primary,
                child: Text(
                  '10',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TextField(
      decoration: InputDecoration(
        constraints: BoxConstraints(maxWidth: size.width / 1.1),
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppBorderSettings.borderRadius),
          ),
        ),
        hintText: 'Search',
      ),
    );
  }
}
