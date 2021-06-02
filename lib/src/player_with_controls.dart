import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:videostremapp/util/sizeConfig.dart';
import 'package:videostremapp/src/chewie_player.dart';
import 'package:videostremapp/src/helpers/adaptive_controls.dart';
import 'package:videostremapp/src/notifiers/index.dart';

class PlayerWithControls extends StatefulWidget {
  const PlayerWithControls({Key? key}) : super(key: key);

  @override
  _PlayerWithControlsState createState() => _PlayerWithControlsState();
}

class _PlayerWithControlsState extends State<PlayerWithControls> {
  CameraController? controller;
  List? cameras;
  int? selectedCameraIndex;
  bool isCameraAvailable = false;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras!.length >= 1) {
        setState(() {
          selectedCameraIndex = 1;
          isCameraAvailable = true;
        });
        _initCameraController(cameras![selectedCameraIndex!]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.veryHigh,enableAudio: true,);

    controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        print('Camera error ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      print(e.toString());
      isCameraAvailable = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    double _calculateAspectRatio(BuildContext context) {
      final size = MediaQuery.of(context).size;
      final width = size.width;
      final height = size.height;

      return width > height ? width / height : height / width;
    }

    Widget _buildControls(
      BuildContext context,
      ChewieController chewieController,
    ) {
      return chewieController.showControls
          ? chewieController.customControls ?? const AdaptiveControls()
          : Container();
    }

  

    Widget _buildPlayerWithControls(
        ChewieController chewieController, BuildContext context) {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          chewieController.placeholder ?? Container(),
          Center(
            child: AspectRatio(
              aspectRatio: chewieController.aspectRatio ??
                  chewieController.videoPlayerController.value.aspectRatio,
              child: VideoPlayer(chewieController.videoPlayerController),
            ),
          ),
          chewieController.overlay ?? Container(),
          if (Theme.of(context).platform != TargetPlatform.iOS)
            Consumer<PlayerNotifier>(
              builder: (
                BuildContext context,
                PlayerNotifier notifier,
                Widget? widget,
              ) =>
                  AnimatedOpacity(
                opacity: notifier.hideStuff ? 0.0 : 0.8,
                duration: const Duration(
                  milliseconds: 250,
                ),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: Container(),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: _buildControls(context, chewieController),
            ),
          isCameraAvailable
              ? Positioned(
                  bottom: SizeConfig.widthMultiplier * 8,
                  right: SizeConfig.widthMultiplier * 12,
                  child: SafeArea(
                      child: Container(
                    height: SizeConfig.heightMultiplier * 12,
                    width: SizeConfig.widthMultiplier * 40,
                    child: _cameraPreviewWidget(),
                  )))
              : Center()
        ],
      );
    }

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: _calculateAspectRatio(context),
          child: _buildPlayerWithControls(chewieController, context),
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: CameraPreview(controller!),
    );
  }
}
