import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.synced,
    required this.uploading,
    required this.retrying,
    required this.waiting,
    required this.queued,
    required this.surface,
    required this.surfaceMuted,
    required this.onSurfaceMuted,
  });

  final Color synced;
  final Color uploading;
  final Color retrying;
  final Color waiting;
  final Color queued;
  final Color surface;
  final Color surfaceMuted;
  final Color onSurfaceMuted;

  static const dark = AppStatusColors(
    synced: green500,
    uploading: blue500,
    retrying: red500,
    waiting: amber500,
    queued: ink300,
    surface: ink800,
    surfaceMuted: ink700,
    onSurfaceMuted: ink300,
  );

  @override
  AppStatusColors copyWith({
    Color? synced,
    Color? uploading,
    Color? retrying,
    Color? waiting,
    Color? queued,
    Color? surface,
    Color? surfaceMuted,
    Color? onSurfaceMuted,
  }) {
    return AppStatusColors(
      synced: synced ?? this.synced,
      uploading: uploading ?? this.uploading,
      retrying: retrying ?? this.retrying,
      waiting: waiting ?? this.waiting,
      queued: queued ?? this.queued,
      surface: surface ?? this.surface,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
    );
  }

  @override
  AppStatusColors lerp(AppStatusColors? other, double t) {
    if (other == null) return this;
    return AppStatusColors(
      synced: Color.lerp(synced, other.synced, t)!,
      uploading: Color.lerp(uploading, other.uploading, t)!,
      retrying: Color.lerp(retrying, other.retrying, t)!,
      waiting: Color.lerp(waiting, other.waiting, t)!,
      queued: Color.lerp(queued, other.queued, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      onSurfaceMuted: Color.lerp(onSurfaceMuted, other.onSurfaceMuted, t)!,
    );
  }
}

enum UploadTone { waiting, retrying, uploading, synced, queued }

extension AppStatusColorsX on BuildContext {
  AppStatusColors get statusColors => Theme.of(this).extension<AppStatusColors>()!;

  Color colorFor(UploadTone tone) => switch (tone) {
        UploadTone.waiting => statusColors.waiting,
        UploadTone.retrying => statusColors.retrying,
        UploadTone.uploading => statusColors.uploading,
        UploadTone.synced => statusColors.synced,
        UploadTone.queued => statusColors.queued,
      };
}
