import 'dart:convert';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_frontend_v1/api/my_api.dart';
import 'package:flutter_app_frontend_v1/auth/auth_page.dart';
import 'package:flutter_app_frontend_v1/models/get_article_info.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var articles = <ArticleInfo>[];
  var _totalDots = 1;
  double _currentPosition = 0.0;
  @override
  void initState() {
    _initData();

    super.initState();
  }

  double _validPosition(double position) {
    if (position >= _totalDots) return 0;
    if (position < 0) return _totalDots - 1.0;
    return position;
  }

  void _updatePosition(double position) {
    setState(() => _currentPosition = _validPosition(position));
  }

  Widget _buildRow(List<Widget> widgets) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widgets,
      ),
    );
  }

  String getCurrentPositionPretty() {
    return (_currentPosition + 1.0).toStringAsPrecision(2);
  }

  _initData() async {
    CallApi().getPublicData("welcomeinfo").then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        articles = list.map((model) => ArticleInfo.fromJson(model)).toList();
        _totalDots = articles.length;
      });
    });
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPosition = _currentPosition.ceilToDouble();
      // _updatePosition(max(--_currentPosition, 0));
      _updatePosition(index.toDouble());
      print(index);
      print(_currentPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("img/icon-hitam.png"),
              )),
            ),
            SizedBox(
              height: 30,
            ),
            _buildRow([
              DotsIndicator(
                dotsCount: _totalDots,
                position: _currentPosition,
                axis: Axis.horizontal,
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                onTap: (pos) {
                  setState(() => _currentPosition = pos);
                },
              )
            ]),
            Container(
              height: 140,
              color: Colors.white,
              child: PageView.builder(
                  onPageChanged: _onPageChanged,
                  controller: PageController(viewportFraction: 1.0),
                  itemCount: articles == null ? 0 : articles.length,
                  itemBuilder: (_, i) {
                    return Container(
                      height: 180,
                      padding:
                          const EdgeInsets.only(top: 5, left: 50, right: 50),
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(right: 10),
                      child: Text(
                        articles[i].article_content == null
                            ? "Nothing "
                            : articles[i].article_content,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
            ),
            Expanded(
                child: Stack(
              children: [
                Positioned(
                    height: 80,
                    bottom: 80,
                    left: (MediaQuery.of(context).size.width - 80) / 2,
                    right: (MediaQuery.of(context).size.width - 80) / 2,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthPage()));
                        },
                        child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_forward_ios,
                                    color: Color(0xFF363f93)),
                              ],
                              // children: <Widget>[
                              //   Text(
                              //     'Get Started',
                              //     style: TextStyle(
                              //         color: Colors.white, fontSize: 26),
                              //   ),
                              // ],
                            ))))
              ],
            ))
          ],
        ));
  }
}
