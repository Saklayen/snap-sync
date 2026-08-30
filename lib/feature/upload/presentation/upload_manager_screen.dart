import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/locator.dart';
import '../../../core/designsystem/components/app_button.dart';
import '../../../core/designsystem/theme/app_status_colors.dart';
import 'upload_bloc.dart';
import 'upload_state.dart';

class UploadManagerScreen extends StatelessWidget {
  const UploadManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadManagerBloc(locator(), locator()),
      child: const _UploadManagerView(),
    );
  }
}

class _UploadManagerView extends StatelessWidget {
  const _UploadManagerView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UploadManagerBloc, UploadManagerState>(
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              _BatchSummary(
                progress: state.progress,
                progressLabel: state.progressLabel,
                bytesLabel: state.bytesLabel,
              ),
              const Divider(height: 1),
              Expanded(
                child: _QueueList(
                  rows: state.rows,
                  pendingLabel: state.pendingLabel,
                  isEmpty: state.isEmpty,
                ),
              ),
              const _NewBatchButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          Text(
            'Upload Manager',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _BatchSummary extends StatelessWidget {
  const _BatchSummary({
    required this.progress,
    required this.progressLabel,
    required this.bytesLabel,
  });

  final double progress;
  final String progressLabel;
  final String bytesLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.statusColors;
    final labelStyle = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(color: colors.onSurfaceMuted, letterSpacing: 1.4);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('BATCH SYNC PROGRESS', style: labelStyle),
              Text(progressLabel, style: labelStyle),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation(colors.uploading),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            bytesLabel,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.onSurfaceMuted),
          ),
        ],
      ),
    );
  }
}

class _QueueList extends StatelessWidget {
  const _QueueList({
    required this.rows,
    required this.pendingLabel,
    required this.isEmpty,
  });

  final List<UploadRowUi> rows;
  final String pendingLabel;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    if (isEmpty) return const _EmptyQueue();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      children: [
        Text(
          pendingLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.statusColors.onSurfaceMuted,
                letterSpacing: 1.4,
              ),
        ),
        const SizedBox(height: 12),
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _QueueRow(row: row),
          ),
      ],
    );
  }
}

class _EmptyQueue extends StatelessWidget {
  const _EmptyQueue();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          'Nothing is queued. Capture a batch and tap Upload Batch to send it.',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: context.statusColors.onSurfaceMuted),
        ),
      ),
    );
  }
}

class _QueueRow extends StatelessWidget {
  const _QueueRow({required this.row});

  final UploadRowUi row;

  @override
  Widget build(BuildContext context) {
    final colors = context.statusColors;

    return Opacity(
      opacity: row.isDimmed ? 0.55 : 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: row.isActive ? colors.surfaceMuted : colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: row.isActive ? colors.uploading : Colors.transparent,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(row.filePath),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    row.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    row.sizeLabel,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: colors.onSurfaceMuted),
                  ),
                  const SizedBox(height: 8),
                  _RowProgress(
                    progress: row.progress,
                    isVisible: row.hasProgressBar,
                  ),
                  Text(
                    row.statusLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: context.colorFor(row.tone),
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowProgress extends StatelessWidget {
  const _RowProgress({required this.progress, required this.isVisible});

  final double progress;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final colors = context.statusColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 4,
          backgroundColor: colors.surface,
          valueColor: AlwaysStoppedAnimation(colors.uploading),
        ),
      ),
    );
  }
}

class _NewBatchButton extends StatelessWidget {
  const _NewBatchButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: AppButton(
        label: 'START NEW UPLOAD BATCH',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
