import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _audioPlayer.setSource(AssetSource('sounds/beep.mp3'));
    _isInitialized = true;
  }

  Future<void> playPhaseChangeSound() async {
    if (!_isInitialized) await initialize();
    await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> playSessionCompleteSound() async {
    if (!_isInitialized) await initialize();
    await _audioPlayer.play(AssetSource('sounds/bomb.mp3'));
    await Vibration.vibrate(duration: 500);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
