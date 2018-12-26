/**
 * Note: I'm lazy
 * There is no data just used active user to set dynamic name
 * you can modify image counts but note images are taken dynamically
 * add images in patter g_{index}.jpg
 * pr's are welcome with data implementation (Other then my stupid lazy work)
 */

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profiles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _animation, _switchAnimationController;
  Animation<double> _curvedAnimation, _fadeAnimation, _switchAnimation;
  double _height;
  double _width;
  int _userImageCount = 4;
  double _imageSizeFactorMax = 9;
  double _imageSizeFactorMin = 2;
  double _imageOverlayLimit = 30.0;
  int _activeUser = 0;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _switchAnimationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween(begin: 1.0, end: 0.0).animate(_animation);
    _switchAnimation = Tween(begin: 1.0, end: 0.0).animate(_switchAnimationController);
    _animation.forward();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _curvedAnimation = Tween(begin: _getEndPoints(_imageSizeFactorMin), end: _getEndPoints(_imageSizeFactorMax)).animate(_animation);
    return Scaffold(
      body: Container(
        height: _height,
        child: Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  height: _curvedAnimation.value,
                  child: child,
                );
              },
              child: Column(
                children: <Widget>[
                  _userProfileImage(),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  top: _curvedAnimation.value - _imageOverlayLimit,
                  left: 0,
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: (() {
                  if (_getEndPoints(_imageSizeFactorMax) == _curvedAnimation.value) {
                    _animation.reverse();
                  } else {
                    _animation.forward();
                  }
                }),
                child: Container(
                  height: (_height / 2) + _imageOverlayLimit,
                  width: _width,
                  child: _userInfo(),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userInfo() {
    double _containerLimit = ((_height / 2) + _imageOverlayLimit) / 2;
    return Column(
      children: <Widget>[
        Container(
          height: _containerLimit,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _switchAnimationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _switchAnimation,
                          child: child,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "User Name $_activeUser",
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.5),
                          ),
                          Text(
                            "Weird Profession $_activeUser",
                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[700], letterSpacing: 1.5),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(),
                    ),
                    OutlineButton(
                      child: Text(
                        "Follow",
                        style: TextStyle(color: Colors.red[800]),
                      ),
                      onPressed: () {},
                      borderSide: BorderSide(color: Colors.red[800], width: 2),
                      shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    ), // This one is copied from Stackoverflow LOL
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(opacity: _fadeAnimation.value, child: child);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "some another a long about what ican't think to put here as demo so just set this", // Yeah i know this is weired
                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Photos",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 21.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          height: ((_height / 2) + _imageOverlayLimit) / 2,
          child: PageView.builder(
            // PageView.builder implementation was a headache!! :(
            // On different screen size overflow issue was here
            // and this damnn this requires static defined height
            // seriously google's flutter team?????
            controller: PageController(viewportFraction: 0.4, initialPage: 1),
            itemCount: _userImageCount,
            pageSnapping: false,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    "assets/images/g_${_activeUser + 1}.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  double _getEndPoints(double _point) {
    /**
     * Tried to make that line [69] shorter will still looks like a train ¯\_(ツ)_/¯
     */
    return _height - (_height / _point);
  }

  Expanded _userProfileImage() {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SizedBox.expand(
            child: PageView.builder(
              controller: PageController(viewportFraction: 1),
              itemCount: _userImageCount,
              physics: PageScrollPhysics(),
              onPageChanged: ((page) {
                _userSwitch(page);
              }),
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/g_${index + 1}.jpg",
                      fit: BoxFit.cover,
                    ),
                    SafeArea(
                      // Those white images!! ლ(ಠ益ಠლ)
                      // Gradient solution
                      child: DecoratedBox(
                        decoration: new BoxDecoration(
                            gradient: new LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ])),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            Expanded(child: Column()),
                            Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30.0,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(child: Column()),
                  AnimatedBuilder(
                    animation: _switchAnimationController,
                    builder: ((context, child) {
                      return FadeTransition(opacity: _switchAnimation, child: child);
                    }),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: _imageOverlayLimit + 20, left: 20.0, right: 20.0),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Was out of numbers ಠ╭╮ಠ
                              // Outnumbered this!! Hell Yeah!!
                              Text("658$_activeUser", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text("followers",
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                  )),
                            ],
                          ),
                          Expanded(child: Column()),
                          Column(
                            children: <Widget>[
                              Text("984$_activeUser", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text("posts",
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                  )),
                            ],
                          ),
                          Expanded(child: Column()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text("327$_activeUser", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text(
                                "following",
                                style: TextStyle(
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _userSwitch(page) {
    _switchAnimationController.forward().then((data) {
      setState(() {
        _activeUser = page;
      });
      _switchAnimationController.reverse();
    });
  }
}
