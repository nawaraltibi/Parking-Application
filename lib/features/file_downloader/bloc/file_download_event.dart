import 'package:equatable/equatable.dart';

/// File Download Event
/// Base class for all file download events
abstract class FileDownloadEvent extends Equatable {
  const FileDownloadEvent();

  @override
  List<Object?> get props => [];
}

/// File Download Started Event
class FileDownloadStarted extends FileDownloadEvent {
  final String url;
  final String savePath;
  final Map<String, String>? headers;

  const FileDownloadStarted({
    required this.url,
    required this.savePath,
    this.headers,
  });

  @override
  List<Object?> get props => [url, savePath, headers];
}

/// File Download Cancelled Event
class FileDownloadCancelled extends FileDownloadEvent {
  const FileDownloadCancelled();
}
