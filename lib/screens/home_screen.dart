import 'package:flutter/material.dart';
import 'package:flash_chat/screens/subscreens/benefits_subscreen.dart';
import 'package:flash_chat/screens/subscreens/urban_planners_subscreen.dart';
import 'package:flash_chat/shared/colors.dart';
import 'package:flash_chat/shared/consts.dart';
import 'package:flash_chat/shared/widgets/paralax.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController controller = ScrollController();
  bool _disabled3D = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.backgroundGreen,
        // Parallax Builder
        child: ParallaxScroll(
          controller: controller,
          physic: ClampingScrollPhysics(),
          children: <Widget>[
            // Welcome Part.
            UrbanPlannersSubscreen(controller: controller),
            // Registration & Login Part.
            BenefitsSubscreen(controller: controller),
          ],
          parallaxBackgroundChildren: _buildParallaxElements(),
          parallaxForegroundChildren: [
            ParallaxElement(
              child: _buildEffectToggle(),
            )
          ],
        ),
      ),
    );
  }

  // Elements for the Background.

  List<ParallaxElement> _buildParallaxElements() {
    return [
      ParallaxElement(
        scrollDelay: Duration(milliseconds: 230),
        child: ParallaxSvgBackground(
          disableDeepEffect: true,
          disableShadow: true,
          settings: ParallaxBackgroundSettings.predefined(),
          svgAssetName: 'assets/svg/background_icons.svg',
          translationOffset: Consts.svgBackgroundIconsOffst,
        ),
      ),
      ParallaxElement(
        scrollDelay: Duration(milliseconds: 230),
        child: ParallaxSvgBackground(
          disableDeepEffect: _disabled3D,
          settings: ParallaxBackgroundSettings.predefined(),
          svgAssetName: 'assets/svg/layer3.svg',
          translationOffset: Consts.svgLayersOffset,
        ),
      ),
      ParallaxElement(
        scrollDelay: Duration(milliseconds: 230),
        child: ParallaxSvgBackground(
          disableDeepEffect: true,
          disableShadow: true,
          settings: ParallaxBackgroundSettings.predefined(),
          svgAssetName: 'assets/svg/layer3_icons.svg',
          translationOffset: Consts.svgLayer3IconsOffst,
        ),
      ),
      ParallaxElement(
        scrollDelay: Duration(milliseconds: 150),
        child: ParallaxSvgBackground(
          disableDeepEffect: _disabled3D,
          settings: ParallaxBackgroundSettings.predefined(),
          svgAssetName: 'assets/svg/layer2.svg',
          translationOffset: Consts.svgLayersOffset,
        ),
      ),
      ParallaxElement(
        scrollDelay: Duration(milliseconds: 150),
        child: ParallaxSvgBackground(
          disableDeepEffect: true,
          disableShadow: true,
          settings: ParallaxBackgroundSettings.predefined(),
          svgAssetName: 'assets/svg/layer2_icons.svg',
          translationOffset: Consts.svgLayer2IconsOffst,
        ),
      ),
      ParallaxElement(
        scrollDelay: Duration(milliseconds: 40),
        child: ParallaxSvgBackground(
          disableDeepEffect: _disabled3D,
          settings: ParallaxBackgroundSettings.predefined(),
          svgAssetName: 'assets/svg/layer1.svg',
          translationOffset: Consts.svgLayersOffset,
        ),
      ),
    ];
  }

  // Toggle Effect 3D / 2D.

  Widget _buildEffectToggle() {
    return IconButton(
      icon: Icon(
        _disabled3D ? Icons.blur_off : Icons.blur_on,
        color: CustomColors.green3,
        size: 30,
      ),
      tooltip: 'On/Off 3D effect',
      onPressed: () {
        setState(() => _disabled3D = !_disabled3D);
      },
    );
  }
}
