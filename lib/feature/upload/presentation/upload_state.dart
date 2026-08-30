import 'package:equatable/equatable.dart';

import '../../../core/designsystem/theme/app_status_colors.dart';

class UploadRowUi extends Equatable {
  const UploadRowUi({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.sizeLabel,
    required this.statusLabel,
    required this.tone,
    required this.progress,
    required this.isActive,
    required this.isDimmed,
    required this.hasProgressBar,
  });

  final int id;
  final String filePath;
  final String fileName;
  final String sizeLabel;
  final String statusLabel;
  final UploadTone tone;
  final double progress;
  final bool isActive;
  final bool isDimmed;
  final bool hasProgressBar;

  @override
  List<Object?> get props => [
        id,
        filePath,
        fileName,
        sizeLabel,
        statusLabel,
        tone,
        progress,
        isActive,
        isDimmed,
        hasProgressBar,
      ];
}

class UploadManagerState extends Equatable {
  const UploadManagerState({
    this.rows = const [],
    this.pendingLabel = '',
    this.progress = 0,
    this.progressLabel = '',
    this.bytesLabel = '',
    this.isEmpty = true,
    this.connectionLabel = '',
    this.connectionTone = UploadTone.queued,
  });

  final List<UploadRowUi> rows;
  final String pendingLabel;
  final double progress;
  final String progressLabel;
  final String bytesLabel;
  final bool isEmpty;
  final String connectionLabel;
  final UploadTone connectionTone;

  UploadManagerState copyWith({
    List<UploadRowUi>? rows,
    String? pendingLabel,
    double? progress,
    String? progressLabel,
    String? bytesLabel,
    bool? isEmpty,
    String? connectionLabel,
    UploadTone? connectionTone,
  }) {
    return UploadManagerState(
      rows: rows ?? this.rows,
      pendingLabel: pendingLabel ?? this.pendingLabel,
      progress: progress ?? this.progress,
      progressLabel: progressLabel ?? this.progressLabel,
      bytesLabel: bytesLabel ?? this.bytesLabel,
      isEmpty: isEmpty ?? this.isEmpty,
      connectionLabel: connectionLabel ?? this.connectionLabel,
      connectionTone: connectionTone ?? this.connectionTone,
    );
  }

  @override
  List<Object?> get props => [
        rows,
        pendingLabel,
        progress,
        progressLabel,
        bytesLabel,
        isEmpty,
        connectionLabel,
        connectionTone,
      ];
}
