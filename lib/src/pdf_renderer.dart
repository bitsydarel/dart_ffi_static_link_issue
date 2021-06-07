// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart' as ffi_ext;
import 'package:flutter/material.dart';

///
class FPDF_LIBRARY_CONFIG extends ffi.Struct {
  /// Version number of the interface. Currently must be 2.
  @ffi.Int32()
  external int version;

  /// Array of paths to scan in place of the defaults when using built-in
  /// FXGE font loading code. The array is terminated by a NULL pointer.
  /// The Array may be NULL itself to use the default paths. May be ignored
  /// entirely depending upon the platform.
  external ffi.Pointer<ffi.Pointer<ffi_ext.Utf8>> userFontPaths;

  // Version 2.

  /// pointer to the v8::Isolate to use, or NULL to force PDFium to create one.
  external ffi.Pointer<ffi.Void> isolate;

  /// The embedder data slot to use in the v8::Isolate to store PDFium's
  /// per-isolate data. The value needs to be between 0 and
  /// v8::Internals::kNumIsolateDataLots (exclusive). Note that 0 is fine
  /// for most embedders.
  @ffi.Int32()
  external int v8EmbedderSlot;

  ///
  factory FPDF_LIBRARY_CONFIG.allocate({
    int version = 2,
    List<String>? userFontPaths,
    ffi.Pointer<ffi.Void>? isolate,
    int v8EmbedderSlot = 0,
  }) {
    ffi.Pointer<ffi.Pointer<ffi_ext.Utf8>> userFontPathsPtr;

    if (userFontPaths == null) {
      userFontPathsPtr = ffi.nullptr;
    } else {
      userFontPathsPtr = ffi_ext.calloc<ffi.Pointer<ffi_ext.Utf8>>();

      for (int i = 0; i < userFontPaths.length; i++) {
        userFontPathsPtr[i] = userFontPaths[i].toNativeUtf8();
      }
    }

    return ffi_ext.calloc<FPDF_LIBRARY_CONFIG>().ref
      ..version = version
      ..userFontPaths = userFontPathsPtr
      ..isolate = isolate ?? ffi.nullptr
      ..v8EmbedderSlot = v8EmbedderSlot;
  }
}

///
class FPDF_DOCUMENT extends ffi.Opaque {}

///
class FPDF_PAGE extends ffi.Opaque {}

///
class FPDF_BITMAP extends ffi.Opaque {}

///
class FPDF_LINK extends ffi.Opaque {}

///
class FPDF_ACTION extends ffi.Opaque {}

///
class FPDF_BOOL extends ffi.Opaque {}

///
class FS_RECTF extends ffi.Struct {
  /// The x-coordinate of the left-top corner.
  @ffi.Float()
  external double left;

  /// The y-coordinate of the left-top corner.
  @ffi.Float()
  external double top;

  /// The x-coordinate of the right-bottom corner.
  @ffi.Float()
  external double right;

  /// The y-coordinate of the right-bottom corner.
  @ffi.Float()
  external double bottom;
}

///
class Link {
  ///
  final Rect rect;

  ///
  final int? destinationPage;

  ///
  final String? uri;

  ///
  Link(this.rect, this.destinationPage, this.uri);
}

/// Function: FPDF_CloseDocument Close a loaded PDF document.
/// Parameters: document - Handle to the loaded document.
/// Return value: None.
typedef FPDF_DestroyLibrary = ffi.Void Function();

/// Function: FPDF_InitLibraryWithConfig
///          Initialize the FPDFSDK library
/// Parameters:
///          config - configuration information as above.
/// Return value:
///          None.
/// Comments:
///          You have to call this function before you can call any PDF
///          processing functions.
typedef FPDF_InitLibraryWithConfig = ffi.Void Function(
  ffi.Pointer<FPDF_LIBRARY_CONFIG> config,
);

/// Function: FPDF_LoadDocument
///          Open and load a PDF document.
/// Parameters:
///          file_path -  Path to the PDF file (including extension).
///          password  -  A string used as the password for the PDF file.
///                       If no password is needed, empty or NULL can be used.
///                       See comments below regarding the encoding.
/// Return value:
///          A handle to the loaded document, or NULL on failure.
/// Comments:
///          Loaded document can be closed by FPDF_CloseDocument().
///          If this function fails, you can use FPDF_GetLastError() to retrieve
///          the reason why it failed.
///
///          The encoding for |password| can be either UTF-8 or Latin-1. PDFs,
///          depending on the security handler revision, will only accept one or
///          the other encoding. If |password|'s encoding and the PDF's expected
///          encoding do not match, FPDF_LoadDocument() will automatically
///          convert |password| to the other encoding.
typedef FPDF_LoadDocument = ffi.Pointer<FPDF_DOCUMENT> Function(
  ffi.Pointer<ffi_ext.Utf8> filePath,
  ffi.Pointer<ffi_ext.Utf8> password,
);

/// Function: FPDF_GetLastError
///          Get last error code when a function fails.
/// Parameters:
///          None.
/// Return value:
///          A 32-bit integer indicating error code as defined above.
/// Comments:
///          If the previous SDK call succeeded, the return value of this
///          function is not defined.
typedef FPDF_GetLastError = ffi.Uint64 Function();

/// Function: FPDFBitmap_GetBuffer Get data buffer of a bitmap.
///
/// Parameters:
///         bitmap - Handle to the bitmap. Returned by FPDFBitmap_Create
///                         or FPDFImageObj_GetBitmap.
/// Return value:
///         The pointer to the first byte of the bitmap buffer.
/// Comments:
///         The stride may be more than width * number of bytes per pixel
///
///         Applications can use this function to get the bitmap buffer pointer,
///         then manipulate any color and/or alpha values for any pixels in the
///         bitmap.
///
///         The data is in BGRA format. Where the A maybe unused if alpha was
///         not specified.
typedef FPDFBitmap_GetBuffer = ffi.Pointer<ffi.Uint32> Function(
  ffi.Pointer<FPDF_BITMAP> bitmap,
);

/// Function: FPDFBitmap_Create
///          Create a device independent bitmap (FXDIB).
/// Parameters:
///          width       -  The number of pixels in width for the bitmap.
///                          Must be greater than 0.
///          height      -  The number of pixels in height for the bitmap.
///                          Must be greater than 0.
///          alpha       -  A flag indicating whether the alpha channel is used.
///                          Non-zero for using alpha, zero for not using.
/// Return value:
///          The created bitmap handle, or NULL if a parameter error or out of
///          memory.
/// Comments:
///          The bitmap always uses 4 bytes per pixel. The first byte is always
///          double word aligned.
///
///          The byte order is BGRx (the last byte unused if no alpha channel)
///          or BGRA.
///
///          The pixels in a horizontal line are stored side by side, with the
///          left most pixel stored first (with lower memory address).
///          Each line uses width * 4 bytes.
///
///          Lines are stored one after another, with the top most line stored
///          first. There is no gap between adjacent lines.
///
///          This function allocates enough memory for holding all pixels in the
///          bitmap, but it doesn't initialize the buffer. Applications can use
///          FPDFBitmap_FillRect() to fill the bitmap using any color. If the OS
///          allows it, this function can allocate up to 4 GB of memory.
typedef FPDFBitmap_Create = ffi.Pointer<FPDF_BITMAP> Function(
  ffi.Int32 width,
  ffi.Int32 height,
  ffi.Int32 alpha,
);

/// Function: FPDF_LoadPage
///          Load a page inside the document.
/// Parameters:
///          document    -   Handle to document. Returned by FPDF_LoadDocument
///          page_index  -   Index number of the page. 0 for the first page.
/// Return value:
///          A handle to the loaded page, or NULL if page load fails.
/// Comments:
///          The loaded page can be rendered to devices using FPDF_RenderPage.
///          The loaded page can be closed using FPDF_ClosePage.
typedef FPDF_LoadPage = ffi.Pointer<FPDF_PAGE> Function(
  ffi.Pointer<FPDF_DOCUMENT> document,
  ffi.Int32 pageIndex,
);

/// Function: FPDFBitmap_FillRect
///          Fill a rectangle in a bitmap.
/// Parameters:
///          bitmap      -   The handle to the bitmap. Returned by
///                          FPDFBitmap_Create.
///          left        -   The left position. Starting from 0 at the
///                          left-most pixel.
///          top         -   The top position. Starting from 0 at the
///                          top-most line.
///          width       -   Width in pixels to be filled.
///          height      -   Height in pixels to be filled.
///          color       -   A 32-bit value specifing the color, in 8888 ARGB
///                          format.
/// Return value:
///          None.
/// Comments:
///          This function sets the color and (optionally) alpha value in the
///          specified region of the bitmap.
///
///          NOTE: If the alpha channel is used, this function does NOT
///          composite the background with the source color, instead the
///          background will be replaced by the source color and the alpha.
///
///          If the alpha channel is not used, the alpha parameter is ignored.
typedef FPDFBitmap_FillRect = ffi.Void Function(
  ffi.Pointer<FPDF_BITMAP> bitmap,
  ffi.Int32 left,
  ffi.Int32 top,
  ffi.Int32 width,
  ffi.Int32 height,
  ffi.Uint32 color,
);

/// Function: FPDF_GetPageWidth
///          Get page width.
/// Parameters:
///          page        -   Handle to the page. Returned by FPDF_LoadPage.
/// Return value:
///          Page width (excluding non-displayable area) measured in points.
///          One point is 1/72 inch (around 0.3528 mm).
typedef FPDF_GetPageWidth = ffi.Double Function(ffi.Pointer<FPDF_PAGE> page);

/// Function: FPDF_GetPageHeight
///          Get page height.
/// Parameters:
///          page        -   Handle to the page. Returned by FPDF_LoadPage.
/// Return value:
///          Page height (excluding non-displayable area) measured in points.
///          One point is 1/72 inch (around 0.3528 mm)
typedef FPDF_GetPageHeight = ffi.Double Function(ffi.Pointer<FPDF_PAGE> page);

/// Function: FPDF_RenderPageBitmap
///          Render contents of a page to a device independent bitmap.
/// Parameters:
///          bitmap      -   Handle to the device independent bitmap (as the
///                          output buffer). The bitmap handle can be created
///                          by FPDFBitmap_Create or retrieved from an image
///                          object by FPDFImageObj_GetBitmap.
///          page        -   Handle to the page. Returned by FPDF_LoadPage
///          start_x     -   Left pixel position of the display area in
///                          bitmap coordinates.
///          start_y     -   Top pixel position of the display area in bitmap
///                          coordinates.
///          size_x      -  Horizontal size (in pixels) for displaying the page.
///          size_y      -   Vertical size (in pixels) for displaying the page.
///          rotate      -   Page orientation:
///                            0 (normal)
///                            1 (rotated 90 degrees clockwise)
///                            2 (rotated 180 degrees)
///                            3 (rotated 90 degrees counter-clockwise)
///          flags       -   0 for normal display, or combination of the Page
///                          Rendering flags defined above. With the FPDF_ANNOT
///                         flag, it renders all annotations that do not require
///                          user-interaction, which are all annotations except
///                          widget and popup annotations.
/// Return value:
///          None.
typedef FPDF_RenderPageBitmap = ffi.Void Function(
  ffi.Pointer<FPDF_BITMAP> bitmap,
  ffi.Pointer<FPDF_PAGE> page,
  ffi.Int32 startX,
  ffi.Int32 startY,
  ffi.Int32 sizeX,
  ffi.Int32 sizeY,
  ffi.Int32 rotate,
  ffi.Int32 flags,
);

/// Function: FPDF_GetPageCount
///          Get total number of pages in the document.
/// Parameters:
///          document    -   Handle to document. Returned by FPDF_LoadDocument.
/// Return value:
///          Total number of pages in the document.
typedef FPDF_GetPageCount = ffi.Int32 Function(
  ffi.Pointer<FPDF_DOCUMENT> document,
);

/// Function: FPDF_CloseDocument
///          Close a loaded PDF document.
/// Parameters:
///          document    -   Handle to the loaded document.
/// Return value:
///          None.
typedef FPDF_CloseDocument = ffi.Void Function(
  ffi.Pointer<FPDF_DOCUMENT> document,
);

/// Function: FPDF_ClosePage
///          Close a loaded PDF page.
/// Parameters:
///          page        -   Handle to the loaded page.
/// Return value:
///          None.
typedef FPDF_ClosePage = ffi.Void Function(ffi.Pointer<FPDF_PAGE> page);

///
class PdfRenderer {
  ///
  final void Function() destroy;

  ///
  final void Function(ffi.Pointer<FPDF_LIBRARY_CONFIG> config) initialize;

  ///
  final ffi.Pointer<FPDF_DOCUMENT> Function(
    ffi.Pointer<ffi_ext.Utf8> filePath,
    ffi.Pointer<ffi_ext.Utf8> password,
  ) loadDocument;

  ///
  final int Function() getLastError;

  ///
  final ffi.Pointer<FPDF_BITMAP> Function(
    int width,
    int height,
    int alpha,
  ) createBitmap;

  ///
  final ffi.Pointer<FPDF_PAGE> Function(
    ffi.Pointer<FPDF_DOCUMENT> document,
    int pageIndex,
  ) loadPage;

  ///
  final ffi.Pointer<ffi.Uint32> Function(
    ffi.Pointer<FPDF_BITMAP> bitmap,
  ) getBitmapBuffer;

  ///
  final void Function(
    ffi.Pointer<FPDF_BITMAP> bitmap,
    int left,
    int top,
    int width,
    int height,
    int color,
  ) fillRectBitmap;

  ///
  final double Function(ffi.Pointer<FPDF_PAGE> page) getPageWidth;

  ///
  final double Function(ffi.Pointer<FPDF_PAGE> page) getPageHeight;

  ///
  final void Function(
    ffi.Pointer<FPDF_BITMAP> bitmap,
    ffi.Pointer<FPDF_PAGE> page,
    int startX,
    int startY,
    int sizeX,
    int sizeY,
    int rotate,
    int flags,
  ) renderPageBitmap;

  ///
  final int Function(ffi.Pointer<FPDF_DOCUMENT> document) getPageCount;

  ///
  final void Function(ffi.Pointer<FPDF_PAGE> page) closePage;

  ///
  final void Function(ffi.Pointer<FPDF_DOCUMENT> document) closeDocument;

  ///
  @visibleForTesting
  PdfRenderer.private({
    required this.destroy,
    required this.initialize,
    required this.loadDocument,
    required this.getLastError,
    required this.createBitmap,
    required this.loadPage,
    required this.getBitmapBuffer,
    required this.fillRectBitmap,
    required this.getPageWidth,
    required this.getPageHeight,
    required this.renderPageBitmap,
    required this.getPageCount,
    required this.closePage,
    required this.closeDocument,
  });

  ///
  factory PdfRenderer.load(final String lib) {
    final ffi.DynamicLibrary pdfium = Platform.isIOS
        ? ffi.DynamicLibrary.process()
        : ffi.DynamicLibrary.open(lib);

    final PdfRenderer renderer = PdfRenderer.private(
      destroy: pdfium
          .lookup<ffi.NativeFunction<FPDF_DestroyLibrary>>(
            'FPDF_DestroyLibrary',
          )
          .asFunction(),
      initialize: pdfium
          .lookup<ffi.NativeFunction<FPDF_InitLibraryWithConfig>>(
            'FPDF_InitLibraryWithConfig',
          )
          .asFunction(),
      loadDocument: pdfium.lookupFunction<FPDF_LoadDocument, FPDF_LoadDocument>(
        'FPDF_LoadDocument',
      ),
      getLastError: pdfium
          .lookup<ffi.NativeFunction<FPDF_GetLastError>>('FPDF_GetLastError')
          .asFunction(),
      createBitmap: pdfium
          .lookup<ffi.NativeFunction<FPDFBitmap_Create>>('FPDFBitmap_Create')
          .asFunction(),
      loadPage: pdfium
          .lookup<ffi.NativeFunction<FPDF_LoadPage>>('FPDF_LoadPage')
          .asFunction(),
      getBitmapBuffer: pdfium
          .lookup<ffi.NativeFunction<FPDFBitmap_GetBuffer>>(
            'FPDFBitmap_GetBuffer',
          )
          .asFunction(),
      fillRectBitmap: pdfium
          .lookup<ffi.NativeFunction<FPDFBitmap_FillRect>>(
            'FPDFBitmap_FillRect',
          )
          .asFunction(),
      getPageWidth: pdfium
          .lookup<ffi.NativeFunction<FPDF_GetPageWidth>>('FPDF_GetPageWidth')
          .asFunction(),
      getPageHeight: pdfium
          .lookup<ffi.NativeFunction<FPDF_GetPageHeight>>('FPDF_GetPageHeight')
          .asFunction(),
      renderPageBitmap: pdfium
          .lookup<ffi.NativeFunction<FPDF_RenderPageBitmap>>(
            'FPDF_RenderPageBitmap',
          )
          .asFunction(),
      getPageCount: pdfium
          .lookup<ffi.NativeFunction<FPDF_GetPageCount>>('FPDF_GetPageCount')
          .asFunction(),
      closePage: pdfium
          .lookup<ffi.NativeFunction<FPDF_ClosePage>>('FPDF_ClosePage')
          .asFunction(),
      closeDocument: pdfium
          .lookup<ffi.NativeFunction<FPDF_CloseDocument>>('FPDF_CloseDocument')
          .asFunction(),
    );

    renderer.initialize(ffi.nullptr);

    return renderer;
  }
}

///
class PDFDocument {
  static const int _pixelPerInch = 100;
  final PdfRenderer _renderer;
  final ffi.Pointer<FPDF_DOCUMENT> _document;
  ui.Image? _currentPage;
  int _currentPageIndex = 0;

  ///
  final int pageCount;

  ///
  @visibleForTesting
  PDFDocument.private(this._renderer, this._document, this.pageCount);

  ///
  factory PDFDocument.load(PdfRenderer renderer, final String filePath) {
    final ffi.Pointer<FPDF_DOCUMENT> document = renderer.loadDocument(
      filePath.toNativeUtf8(),
      ffi.nullptr,
    );

    final int pageCount = renderer.getPageCount(document);

    return PDFDocument.private(renderer, document, pageCount);
  }

  ///
  ui.Image? get currentPage => _currentPage;

  ///
  int get currentPageIndex => _currentPageIndex;

  ///
  Future<ui.Image> loadPage(final int index) async {
    final Completer<ui.Image> imageConversion = Completer<ui.Image>();

    final ffi.Pointer<FPDF_PAGE> page = _renderer.loadPage(_document, index);

    final double pageWidthPoints = _renderer.getPageWidth(page);
    final double pageHeightPoints = _renderer.getPageHeight(page);

    final int pageWidth =
        pointsToPixels(pageWidthPoints, _pixelPerInch).round();

    final int pageHeight =
        pointsToPixels(pageHeightPoints, _pixelPerInch).round();

    final ffi.Pointer<FPDF_BITMAP> bitmap = _renderer.createBitmap(
      pageWidth,
      pageHeight,
      1,
    );

    _renderer.fillRectBitmap(bitmap, 0, 0, pageWidth, pageHeight, 0);
    _renderer.renderPageBitmap(bitmap, page, 0, 0, pageWidth, pageHeight, 0, 0);

    final Uint8List imageData = _renderer
        .getBitmapBuffer(bitmap)
        .asTypedList(pageWidth * pageHeight)
        .buffer
        .asUint8List();

    ui.decodeImageFromPixels(
      imageData,
      pageWidth,
      pageHeight,
      ui.PixelFormat.rgba8888,
      imageConversion.complete,
    );

    final ui.Image image = await imageConversion.future;
    _currentPage = image;
    _currentPageIndex = index;

    _renderer.closePage(page);

    return image;
  }

  ///
  static double pointsToPixels(double points, int ppi) {
    return points / 72 * ppi;
  }
}
