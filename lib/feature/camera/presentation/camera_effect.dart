sealed class CameraEffect {
  const CameraEffect();
}

final class OpenAppSettingsEffect extends CameraEffect {
  const OpenAppSettingsEffect();
}

final class ShowMessageEffect extends CameraEffect {
  const ShowMessageEffect(this.message);

  final String message;
}
