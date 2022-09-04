import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  double height1 = 0;
  double height2 = 0;
  GlobalKey globalKey1 = GlobalKey();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final double viewportDimension =
          scrollController.position.viewportDimension;
      final double offset = scrollController.offset;
      if (globalKey1.currentContext == null) return;
      final double widetHeight = getWidgetHeight(globalKey1);
      final double widetPositionHeight = getWidgetPositionHeight(globalKey1);

      if (offset + viewportDimension > widetPositionHeight + widetHeight) {
        onChangeHeight();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.amber,
                height: 1000,
                child: Column(
                  children: [
                    Row(),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      size: 200,
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      size: 200,
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      size: 200,
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      size: 200,
                    ),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      size: 200,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    key: globalKey1,
                    alignment: Alignment.bottomCenter,
                    children: [
                      const SizedBox(
                        height: 200,
                        width: 20,
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 2000),
                        width: 40,
                        height: height1,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        curve: Curves.fastOutSlowIn,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  VisibilityDetector(
                    key: const Key('second'),
                    onVisibilityChanged: (visibilityInfo) async {
                      if (height2 == 150) {
                        return;
                      }
                      final visiblePercentage =
                          visibilityInfo.visibleFraction * 100;
                      if (height2 == 0 && visiblePercentage == 100) {
                        await Future.delayed(const Duration(milliseconds: 300),
                            () {
                          setState(() {
                            height2 = 150;
                          });
                        });
                      }
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        const SizedBox(
                          height: 200,
                          width: 20,
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 2000),
                          width: 40,
                          height: height2,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          curve: Curves.fastOutSlowIn,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.amber,
                height: 900,
                child: Column(
                  children: [
                    Row(),
                    const Icon(
                      Icons.arrow_upward_rounded,
                      size: 200,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onChangeHeight() {
    if (height1 == 150) return;
    setState(() {
      height1 = 150;
    });
  }
}

double getWidgetHeight(GlobalKey key) {
  final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
  Size size = renderBox.size;
  return size.height;
}

double getWidgetPositionHeight(GlobalKey key) {
  final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero);
  return position.dy;
}
