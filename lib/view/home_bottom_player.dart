import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_filip/view/player/player_view.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_filip/res/app_icons.dart';
import 'package:flutter_filip/res/app_colors.dart';
import 'package:flutter_filip/res/app_svg.dart';

import 'package:just_audio/just_audio.dart';

class HomeBottomPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: 20,
      duration: const Duration(milliseconds: 300),
      child: OpenContainerWrapper(
        transitionType: ContainerTransitionType.fade,
        closedBuilder: (context, openContainer) {
          return BottomPlayer(openContainer: openContainer);
        },
      ),
    ); // child: BottomPlayer());
  }
}

class BottomPlayer extends StatelessWidget {
  const BottomPlayer({
    required this.openContainer,
  });

  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width - 40,
        child: Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: GestureDetector(
                onTap: openContainer,
                child: Container(
                  height: 80,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 27,
                        backgroundImage: AssetImage(AppIcons.splashIcons),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'test',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'test',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              width: 120,
                              child: LinearProgressIndicator(
                                borderRadius: BorderRadius.circular(10),
                                backgroundColor: Colors.grey.withOpacity(.1),
                                color: blueBackground,
                                value: 0.5,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              // Play without waiting for completion
                            },
                            child: RotatedBox(
                                quarterTurns: 2,
                                child: SvgPicture.asset(
                                  AppSvg.prev,
                                  height: 20,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final player = AudioPlayer(); // Create a player
                              final duration = await player.setUrl(
                                  // Load a URL
                                  'http://evans.x3322.net:6788/d/kuake/%E9%9F%B3%E4%B9%90/%E6%8A%96%E9%9F%B32024-3%E6%9C%88%E7%83%AD%E6%AD%8C/2022-2023%E5%B9%B4%E5%90%88%E9%9B%86/%E5%91%A8%E6%9D%B0%E4%BC%A6-%E5%A4%9C%E6%9B%B2.mp3'); // Schemes: (https: | file: | asset: )
                              print("play obj");
                              player.play();
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: blueBackground,
                              child: Center(
                                child: SvgPicture.asset(
                                  AppSvg.play,
                                  color: Colors.white,
                                  width: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              AppSvg.next,
                              height: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
