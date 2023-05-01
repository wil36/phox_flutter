import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phox_mizz_up/helpers.dart';
import 'package:phox_mizz_up/services/database_service.dart';

class MyFiltersScreen extends StatefulWidget {
  const MyFiltersScreen({super.key});

  @override
  State<MyFiltersScreen> createState() => _MyFiltersScreenState();
}

class _MyFiltersScreenState extends State<MyFiltersScreen> {
  var box = Hive.box('Phox');
  Stream<QuerySnapshot>? filtersList;
  bool _noObject = false;

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
            const SizedBox(
              height: 30,
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
            const SizedBox(
              height: 10,
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
            const SizedBox(
              height: 10,
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
            const SizedBox(
              height: 10,
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
            const SizedBox(
              height: 10,
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
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      FeatherIcons.facebook,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      FeatherIcons.instagram,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(
                      Icons.tiktok,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {},
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
            const SizedBox(
              height: 20,
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
        title: const Image(
          image: AssetImage('assets/logo.png'),
          width: 120,
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
            const SizedBox(
              height: 30,
            ),
            const Text(
              "MY FILTERS",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.white,
                height: 3,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.09,
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
                                          const SizedBox(
                                            height: 5,
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
                                            minHeight: 7,
                                          ),
                                        ],
                                      ),
                                      leading: Container(
                                        height: 30,
                                        width: 30,
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
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                          separatorBuilder: (context, index) => const Divider(
                                height: 1,
                                color: Colors.white,
                              ),
                          itemCount: snapshot.data.docs.length)
                      : Container();
                },
              ),
            ),
            const SizedBox(
              height: 20,
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
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 40,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _noObject
                            ? "ADD NEW FILTER"
                            : "You have no filter timers currently.\nClick to add your first one!",
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
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
}
