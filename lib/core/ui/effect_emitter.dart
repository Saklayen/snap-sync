import 'dart:async';

mixin EffectEmitter<E> {
  final StreamController<E> _effects = StreamController<E>();

  Stream<E> get effects => _effects.stream;

  void emitEffect(E effect) => _effects.add(effect);

  Future<void> closeEffects() => _effects.close();
}
