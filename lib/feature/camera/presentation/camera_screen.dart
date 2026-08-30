import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/designsystem/theme/app_colors.dart';
import '../../../core/ui/effect_listener.dart';
import '../../../app/locator.dart';
import 'camera_bloc.dart';
import 'camera_effect.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CameraBloc(locator(), locator())..add(const CameraStarted()),
      child: const _CameraView(),
    );
  }
}

class _CameraView extends StatefulWidget {
  const _CameraView();

  @override
  State<_CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<_CameraView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    final bloc = context.read<CameraBloc>();

    switch (lifecycle) {
      case AppLifecycleState.resumed:
        bloc.add(const CameraResumed());
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        bloc.add(const CameraStopped());
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return EffectListener<CameraEffect>(
      effects: context.read<CameraBloc>().effects,
      onEffect: (context, effect) => switch (effect) {
        OpenAppSettingsEffect() => openAppSettings(),
        ShowMessageEffect(:final message) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message))),
      },
      child: Scaffold(
        body: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) => switch (state.status) {
            CameraStatus.ready when state.controller != null => _CameraSurface(
                controller: state.controller!,
                zoom: state.zoom,
                minZoom: state.minZoom,
                maxZoom: state.maxZoom,
                minZoomLabel: state.minZoomLabel,
                maxZoomLabel: state.maxZoomLabel,
                zoomOptions: state.zoomOptions,
                isZoomAdjustable: state.isZoomAdjustable,
                focusPoint: state.focusPoint,
                isFocusLocked: state.isFocusLocked,
                onZoomChanged: (level) =>
                    context.read<CameraBloc>().add(CameraZoomChanged(level)),
                onFocusRequested: (point) =>
                    context.read<CameraBloc>().add(CameraFocusRequested(point)),
                onFocusReleased: () =>
                    context.read<CameraBloc>().add(const CameraFocusReleased()),
                latestCapturePath: state.latestCapturePath,
                captureBadgeLabel: state.captureBadgeLabel,
                hasCaptures: state.hasCaptures,
                isCapturing: state.isCapturing,
                onCapturePressed: () =>
                    context.read<CameraBloc>().add(const CameraCaptureRequested()),
              ),
            CameraStatus.starting => const _Starting(),
            _ => _Unavailable(
                message: state.message,
                actionLabel: state.recoveryLabel,
                showAction: state.hasRecovery,
                onAction: () =>
                    context.read<CameraBloc>().add(const CameraRecoveryRequested()),
              ),
          },
        ),
      ),
    );
  }
}

class _Starting extends StatelessWidget {
  const _Starting();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _CameraSurface extends StatelessWidget {
  const _CameraSurface({
    required this.controller,
    required this.zoom,
    required this.minZoom,
    required this.maxZoom,
    required this.minZoomLabel,
    required this.maxZoomLabel,
    required this.zoomOptions,
    required this.isZoomAdjustable,
    required this.focusPoint,
    required this.isFocusLocked,
    required this.onZoomChanged,
    required this.onFocusRequested,
    required this.onFocusReleased,
    required this.latestCapturePath,
    required this.captureBadgeLabel,
    required this.hasCaptures,
    required this.isCapturing,
    required this.onCapturePressed,
  });

  final CameraController controller;
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final String minZoomLabel;
  final String maxZoomLabel;
  final List<ZoomOption> zoomOptions;
  final bool isZoomAdjustable;
  final Offset focusPoint;
  final bool isFocusLocked;
  final ValueChanged<double> onZoomChanged;
  final ValueChanged<Offset> onFocusRequested;
  final VoidCallback onFocusReleased;
  final String latestCapturePath;
  final String captureBadgeLabel;
  final bool hasCaptures;
  final bool isCapturing;
  final VoidCallback onCapturePressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        fit: StackFit.expand,
        children: [
          _CameraGestures(
            zoom: zoom,
            size: constraints.biggest,
            onZoomChanged: onZoomChanged,
            onFocusRequested: onFocusRequested,
            child: _Preview(controller: controller),
          ),
          _FocusIndicator(
            center: Offset(
              focusPoint.dx * constraints.maxWidth,
              focusPoint.dy * constraints.maxHeight,
            ),
            isVisible: isFocusLocked,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: _ZoomSlider(
                zoom: zoom,
                minZoom: minZoom,
                maxZoom: maxZoom,
                minLabel: minZoomLabel,
                maxLabel: maxZoomLabel,
                isVisible: isZoomAdjustable,
                onChanged: onZoomChanged,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FocusLockChip(
                  isVisible: isFocusLocked,
                  onPressed: onFocusReleased,
                ),
                const SizedBox(height: 20),
                _ZoomPills(options: zoomOptions, onSelected: onZoomChanged),
                const SizedBox(height: 28),
                _ShutterRow(
                  latestCapturePath: latestCapturePath,
                  badgeLabel: captureBadgeLabel,
                  hasCaptures: hasCaptures,
                  isCapturing: isCapturing,
                  onCapturePressed: onCapturePressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraGestures extends StatefulWidget {
  const _CameraGestures({
    required this.zoom,
    required this.size,
    required this.onZoomChanged,
    required this.onFocusRequested,
    required this.child,
  });

  final double zoom;
  final Size size;
  final ValueChanged<double> onZoomChanged;
  final ValueChanged<Offset> onFocusRequested;
  final Widget child;

  @override
  State<_CameraGestures> createState() => _CameraGesturesState();
}

class _CameraGesturesState extends State<_CameraGestures> {
  double _baseline = 1;

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount < 2) return;
    widget.onZoomChanged(_baseline * details.scale);
  }

  void _onTapDown(TapDownDetails details) {
    widget.onFocusRequested(Offset(
      details.localPosition.dx / widget.size.width,
      details.localPosition.dy / widget.size.height,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onScaleStart: (_) => _baseline = widget.zoom,
      onScaleUpdate: _onScaleUpdate,
      child: widget.child,
    );
  }
}

class _FocusIndicator extends StatelessWidget {
  const _FocusIndicator({required this.center, required this.isVisible});

  static const double _size = 76;

  final Offset center;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned(
      left: center.dx - _size / 2,
      top: center.dy - _size / 2,
      child: TweenAnimationBuilder<double>(
        key: ValueKey(center),
        tween: Tween(begin: 1.35, end: 1),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: white, width: 1.5),
          ),
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: white),
            ),
          ),
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.previewSize?.height ?? 1,
          height: controller.value.previewSize?.width ?? 1,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

class _ZoomPills extends StatelessWidget {
  const _ZoomPills({required this.options, required this.onSelected});

  final List<ZoomOption> options;
  final ValueChanged<double> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _ZoomPill(
              label: option.label,
              isSelected: option.isSelected,
              onPressed: () => onSelected(option.level),
            ),
          ),
      ],
    );
  }
}

class _ZoomPill extends StatelessWidget {
  const _ZoomPill({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? white : overlayStrong,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected ? ink900 : white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

class _ZoomSlider extends StatelessWidget {
  const _ZoomSlider({
    required this.zoom,
    required this.minZoom,
    required this.maxZoom,
    required this.minLabel,
    required this.maxLabel,
    required this.isVisible,
    required this.onChanged,
  });

  final double zoom;
  final double minZoom;
  final double maxZoom;
  final String minLabel;
  final String maxLabel;
  final bool isVisible;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      width: 44,
      height: 260,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: overlay,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          _ZoomBound(label: maxLabel),
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 2,
                  activeTrackColor: white,
                  inactiveTrackColor: onOverlayMuted,
                  thumbColor: white,
                  overlayColor: Colors.transparent,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  value: zoom.clamp(minZoom, maxZoom),
                  min: minZoom,
                  max: maxZoom,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
          _ZoomBound(label: minLabel),
        ],
      ),
    );
  }
}

class _ZoomBound extends StatelessWidget {
  const _ZoomBound({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: onOverlayMuted),
    );
  }
}

class _ShutterRow extends StatelessWidget {
  const _ShutterRow({
    required this.latestCapturePath,
    required this.badgeLabel,
    required this.hasCaptures,
    required this.isCapturing,
    required this.onCapturePressed,
  });

  static const double _sideSlot = 64;

  final String latestCapturePath;
  final String badgeLabel;
  final bool hasCaptures;
  final bool isCapturing;
  final VoidCallback onCapturePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: _sideSlot,
            child: _BatchThumbnail(
              path: latestCapturePath,
              badgeLabel: badgeLabel,
              isVisible: hasCaptures,
            ),
          ),
          _ShutterButton(isCapturing: isCapturing, onPressed: onCapturePressed),
          const SizedBox(width: _sideSlot),
        ],
      ),
    );
  }
}

class _BatchThumbnail extends StatelessWidget {
  const _BatchThumbnail({
    required this.path,
    required this.badgeLabel,
    required this.isVisible,
  });

  final String path;
  final String badgeLabel;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(path),
            key: ValueKey(path),
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: blue500,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badgeLabel,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: white, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({required this.isCapturing, required this.onPressed});

  final bool isCapturing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: white, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: AnimatedScale(
            scale: isCapturing ? 0.82 : 1,
            duration: const Duration(milliseconds: 120),
            child: const DecoratedBox(
              decoration: BoxDecoration(shape: BoxShape.circle, color: white),
            ),
          ),
        ),
      ),
    );
  }
}

class _FocusLockChip extends StatelessWidget {
  const _FocusLockChip({required this.isVisible, required this.onPressed});

  final bool isVisible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: overlayStrong,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: amber500),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'AF LOCK',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: amber500,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.close_rounded, size: 14, color: amber500),
          ],
        ),
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({
    required this.message,
    required this.actionLabel,
    required this.showAction,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final bool showAction;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.no_photography_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _RecoveryButton(
              label: actionLabel,
              isVisible: showAction,
              onPressed: onAction,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoveryButton extends StatelessWidget {
  const _RecoveryButton({
    required this.label,
    required this.isVisible,
    required this.onPressed,
  });

  final String label;
  final bool isVisible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(label),
    );
  }
}
