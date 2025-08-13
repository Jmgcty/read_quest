import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/handler/appwrite_file_handler.dart';
import 'package:read_quest/core/model/book_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerWithPageTracking extends ConsumerStatefulWidget {
  final BookModel book; // your PDF byte data

  const PdfViewerWithPageTracking({super.key, required this.book});

  @override
  ConsumerState<PdfViewerWithPageTracking> createState() =>
      _PdfViewerWithPageTrackingState();
}

class _PdfViewerWithPageTrackingState
    extends ConsumerState<PdfViewerWithPageTracking> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Optional: preload current page
    _pdfViewerController.addListener(() {
      setState(() {
        _currentPage = _pdfViewerController.pageNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncFileData = ref.watch(appwriteFileProvider(widget.book.file));
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: asyncFileData.when(
        data: (fileData) {
          if (fileData == null) {
            return const Center(child: Text('No data available'));
          }
          return Column(
            children: [
              Expanded(
                child: SfPdfViewer.memory(
                  initialZoomLevel: 3.0,
                  fileData,
                  controller: _pdfViewerController,
                  onPageChanged: (PdfPageChangedDetails details) {
                    setState(() {
                      _currentPage = details.newPageNumber;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Current Page: $_currentPage'),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
