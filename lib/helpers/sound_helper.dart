import 'package:assets_audio_player/assets_audio_player.dart';

final assetsAudioPlayer = AssetsAudioPlayer();

void playSound(sound) async {
  //"assets/maybe-next-time.wav"
  try {
    await assetsAudioPlayer.open(
      Audio("$sound"),
    );
  } catch (ex) {
    print("audio exception: $ex");
  }
}
