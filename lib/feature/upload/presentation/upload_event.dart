import 'package:equatable/equatable.dart';

import '../../../core/data/database/app_database.dart';

sealed class UploadManagerEvent extends Equatable {
  const UploadManagerEvent();

  @override
  List<Object?> get props => const [];
}

final class UploadQueueChanged extends UploadManagerEvent {
  const UploadQueueChanged(this.items);

  final List<UploadItem> items;

  @override
  List<Object?> get props => [items];
}
