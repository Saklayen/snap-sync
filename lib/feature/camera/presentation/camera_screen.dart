import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/ui/effect_listener.dart';
import '../data/camera_data_source.dart';
import 'camera_bloc.dart';
import 'camera_effect.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CameraBloc(CameraDataSource())..add(const CameraStarted()),
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
      },
      child: Scaffold(
        body: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) => switch (state.status) {
            CameraStatus.ready when state.controller != null =>
              _Preview(controller: state.controller!),
            CameraStatus.starting => const _Starting(),
            _ => _Unavailable(
                  message: state.message,
                  actionLabel: state.recoveryLabel,
                  showAction: state.hasRecovery,
              onAction: () => context
                  .read<CameraBloc>()
                  .add(const CameraRecoveryRequested()),
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
