// ignore_for_file: unused_result

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/model/book_model.dart';
import 'package:read_quest/features/home/provider/get_realtime_book_list.dart';
import 'package:read_quest/features/home/views/admin/screen/dashboard/book_management/upload_book/add_book.dart';

class BooksTableScreen extends ConsumerStatefulWidget {
  const BooksTableScreen({super.key});

  @override
  ConsumerState<BooksTableScreen> createState() => _BooksTableScreenState();
}

class _BooksTableScreenState extends ConsumerState<BooksTableScreen> {
  @override
  void initState() {
    super.initState();

    ref.refresh(getRealTimeAcceptedBooksProvider);
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(getRealTimeAcceptedBooksProvider);

    //
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('Books Table'),
        centerTitle: true,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => const AddBookScreen()),
              );
            },
            icon: const Icon(Icons.add_box),
          ),
        ],
      ),
      body: books.when(
        data: (book) => BookTable(book: book),
        error: (error, _) => ErrorScreen(error: error.toString()),
        loading: () => LoadingScreen(),
      ),
    );
  }
}

class BookTable extends StatelessWidget {
  const BookTable({required this.book, super.key});
  final List<BookModel> book;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width / 16),
      child: DataTable2(
        headingRowDecoration: BoxDecoration(color: AppColors.grey),
        border: TableBorder.symmetric(
          outside: BorderSide(width: 1, color: AppColors.grey),
        ),
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        columns: const [
          DataColumn(
            label: Text(
              'ID',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn2(
            label: Text(
              'Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            size: ColumnSize.L,
          ),
          DataColumn(
            label: Text(
              'Uploader',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Accepted',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn(
            label: Text('Actions', style: TextStyle(color: Colors.white)),
          ),
        ],
        rows: List<DataRow>.generate(
          book.length,
          (index) => DataRow(
            cells: [
              DataCell(Text(book[index].id)),
              DataCell(Text(book[index].title)),
              DataCell(Text(book[index].uploader?.name ?? 'N/A')),
              DataCell(Text(book[index].accepted_at ?? 'N/A')),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.amber),
                      onPressed: () {
                        // Handle edit action
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Handle delete action
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({required this.error, super.key});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}
