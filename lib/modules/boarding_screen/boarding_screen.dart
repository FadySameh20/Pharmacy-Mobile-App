import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/components/components.dart';
import '../../shared/network/shared_preferences.dart';
import '../entry_screens/entry_screen.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController pageViewController = PageController();
    int pageIndex = 0;
    List boardings = [
      {
        "image":
            "https://thumbs.dreamstime.com/z/pharmacy-otc-products-turkey-64209774.jpg",
        "title": "Welcome to Pharmacy App",
        "body": "The perfect app made especially for you"
      },
      {
        "image":
            "https://thumbs.dreamstime.com/z/pharmacy-interior-shalldow-depth-field-58158769.jpg",
        "title": "Simplicity",
        "body": "This app is user friendly"
      },
      {
        "image": "https://thumbs.dreamstime.com/z/pharmacy-18612966.jpg",
        "title": "Safe",
        "body": "This app ensure that all customers are safe"
      },
    ];
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  CacheHelper.setData(key: 'boarding', value: true);
                  navigateAndReplace(context, const EntryScreen());
                },
                child: const Text(
                  'SKIP',
                  style: TextStyle(fontSize: 16),
                ))
          ],
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                    controller: pageViewController,
                    itemCount: boardings.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      pageIndex = index;
                      return pageViewBuilder(
                          boardings[pageIndex]["image"],
                          boardings[pageIndex]["title"],
                          boardings[pageIndex]["body"]);
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SmoothPageIndicator(
                      controller: pageViewController,
                      count: boardings.length,
                      axisDirection: Axis.horizontal,
                      effect: const ExpandingDotsEffect(
                        expansionFactor: 3,
                        spacing: 8.0,
                        radius: 4.0,
                        dotWidth: 16.0,
                        dotHeight: 16.0,
                        // paintStyle:  PaintingStyle.stroke,
                        strokeWidth: 1.5,
                        dotColor: Colors.grey,
                        activeDotColor: Colors.blue,
                      ),
                    ),
                    const Spacer(),
                    FloatingActionButton(
                      onPressed: () {
                        if (pageIndex == 2) {
                          CacheHelper.setData(key: 'boarding', value: true);
                          navigateAndReplace(context, const EntryScreen());
                        } else {
                          pageViewController.nextPage(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                      },
                      child: const Icon(Icons.navigate_next),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

Widget pageViewBuilder(String url, String title, String body) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              image:
                  DecorationImage(fit: BoxFit.fill, image: NetworkImage(url)),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
        ),
      ),
      Text(title),
      Text(body),
      const Spacer(),
    ],
  );
}
