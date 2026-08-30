import 'dart:async';

import 'package:flutter/widgets.dart';

class EffectListener<E> extends StatefulWidget {
  const EffectListener({
    super.key,
    required this.effects,
    required this.onEffect,
    required this.child,
  });

  final Stream<E> effects;
  final void Function(BuildContext context, E effect) onEffect;
  final Widget child;

  @override
  State<EffectListener<E>> createState() => _EffectListenerState<E>();
}

class _EffectListenerState<E> extends State<EffectListener<E>> {
  StreamSubscription<E>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.effects.listen(_handle);
  }

  void _handle(E effect) {
    if (!mounted) return;
    widget.onEffect(context, effect);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
