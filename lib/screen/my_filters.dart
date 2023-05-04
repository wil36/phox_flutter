import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phox_mizz_up/helpers.dart';
import 'package:phox_mizz_up/services/database_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFiltersScreen extends StatefulWidget {
  const MyFiltersScreen({super.key});

  @override
  State<MyFiltersScreen> createState() => _MyFiltersScreenState();
}

class _MyFiltersScreenState extends State<MyFiltersScreen> {
  var box = Hive.box('Phox');
  Stream<QuerySnapshot>? filtersList;

  @override
  void initState() {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getFilterListOfUser()
        .then((value) {
      // Get data from docs and convert map to List
      setState(() {
        filtersList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 35,
                    )),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            ListTile(
              title: const Text(
                'MY FILTERS',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/myFilters');
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              title: const Text(
                'BUY NEW REFILL PACK',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              title: const Text(
                "FAQ'S",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              title: const Text(
                "CONTACT US",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/contact');
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              title: const Text(
                "LOGOUT",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                box.deleteAll({
                  'STATUTLOGIN',
                  'USERNAME',
                  'USEREMAIL',
                  'KEYDOCCURRENTFILTEROPEN',
                });
                Navigator.pushReplacementNamed(context, '/signupLoginQuestion');
              },
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchUrl("https://www.facebook.com/phoxwater");
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      FeatherIcons.facebook,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                GestureDetector(
                  onTap: () {
                    _launchUrl("https://www.instagram.com/phoxwater");
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      FeatherIcons.instagram,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                GestureDetector(
                  onTap: () {
                    _launchUrl("https://www.tiktok.com/@phoxwater");
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      Icons.tiktok,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                GestureDetector(
                  onTap: () {
                    _launchUrl("https://twitter.com/PhoxWater");
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      FeatherIcons.twitter,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                GestureDetector(
                  onTap: () {
                    _launchUrl("https://www.youtube.com/phoxwater");
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      FeatherIcons.youtube,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            const Center(
              child: Image(
                image: AssetImage(
                  "assets/logo2.png",
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary, // <-- SEE HERE
        ),
        title: Image(
          image: const AssetImage('assets/logo.png'),
          width: 120.w,
        ),
        elevation: 0,
        centerTitle: true,
        // leading: Icon(
        //   Icons.menu,
        //   color: Theme.of(context).colorScheme.secondary,
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            const Text(
              "MY FILTERS",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.white,
                height: 3.h,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              width: ScreenUtil().screenWidth > 500
                  ? MediaQuery.of(context).size.width / 2
                  : MediaQuery.of(context).size.width / 1.09,
              child: StreamBuilder(
                stream: filtersList,
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.hasData && snapshot.data.docs.length > 0
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  box.put("KEYDOCCURRENTFILTEROPEN",
                                      snapshot.data.docs[index]['filterId']);
                                  Navigator.pushNamed(context, '/detailFilter');
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        snapshot.data.docs[index]['name'],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${((DateTime.parse(snapshot.data.docs[index]['dateExpires']).difference(DateTime.now()).inDays)).toString()} days left of filter",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          LinearProgressIndicator(
                                            backgroundColor: Colors.white,
                                            value: (timeDurationOfFilter -
                                                    (DateTime.parse(snapshot
                                                                .data
                                                                .docs[index]
                                                            ['dateExpires'])
                                                        .difference(
                                                            DateTime.now())
                                                        .inDays)) /
                                                timeDurationOfFilter,
                                            valueColor: AlwaysStoppedAnimation(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            minHeight: 7.h,
                                          ),
                                        ],
                                      ),
                                      leading: Container(
                                        height: 30.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        child: Center(
                                            child: Text(
                                          "${index + 1}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                  ],
                                ),
                              ),
                          separatorBuilder: (context, index) => Divider(
                                height: 1.h,
                                color: Colors.white,
                              ),
                          itemCount: snapshot.data.docs.length)
                      : Container();
                },
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/addFilters');
              },
              child: DottedBorder(
                color: Theme.of(context)
                    .colorScheme
                    .secondary, //color of dotted/dash line
                strokeWidth: 3, //thickness of dash/dots
                dashPattern: const [8, 7],
                child: SizedBox(
                  height: 130,
                  width: ScreenUtil().screenWidth > 500
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 40,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text(
                        "ADD NEW FILTER",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
    }
  }
}
