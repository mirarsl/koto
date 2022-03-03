import 'package:flutter/material.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:koto/const.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Future<dynamic> videoBottomSheet(BuildContext context, String? videoLink) {
  String? id = YoutubePlayer.convertUrlToId(videoLink!);
  YoutubePlayerController _controller;
  _controller = YoutubePlayerController(
    initialVideoId: id!,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
    ),
  );
  return Navigator.of(context).push(
    HeroDialogRoute<void>(
      builder: (BuildContext context) => InteractiveviewerGallery(
        sources: [videoLink],
        initIndex: 0,
        itemBuilder: (context, index, status) => YoutubePlayer(
          width: MediaQuery.of(context).size.width,
          controller: _controller,
          aspectRatio: 16 / 9,
          progressIndicatorColor: mainColor,
          progressColors: const ProgressBarColors(
            playedColor: mainColor,
            handleColor: mainColor,
          ),
        ),
      ),
    ),
  );
}
