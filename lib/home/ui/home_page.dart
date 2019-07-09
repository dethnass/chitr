import 'package:chitr/home/model/ImageModel.dart';
import 'package:chitr/image/ui/image_page.dart';
import 'package:chitr/util/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'custom_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PreloadPageController> controllers = [];

  @override
  void initState() {
    controllers = [
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
    ];
    super.initState();
  }

  _animatePage(int page, int index) {
    for (int i = 0; i < 5; i++) {
      if (i != index) {
        controllers[i].animateToPage(page,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: ApiProvider().getRandomImages(25),
        builder: (context, AsyncSnapshot<ImageModel> snapshot) {
          if (snapshot.hasData) {
            return PreloadPageView.builder(
              controller:
                  PreloadPageController(viewportFraction: 0.7, initialPage: 3),
              itemCount: 5,
              preloadPagesCount: 5,
              itemBuilder: (context, mainIndex) {
                return PreloadPageView.builder(
                  itemCount: 5,
                  preloadPagesCount: 5,
                  controller: controllers[mainIndex],
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  onPageChanged: (page) {
                    _animatePage(page, mainIndex);
                  },
                  itemBuilder: (context, index) {
                    var hitIndex = (mainIndex * 5) + index;
                    var hit = snapshot.data.hits[hitIndex];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImagePage(model: hit),
                          ),
                        );
                      },
                      child: CustomCard(
                        title: hit.user,
                        description: hit.tags,
                        url: hit.webformatURL,
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
