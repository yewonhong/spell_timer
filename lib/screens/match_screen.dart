import 'package:flutter/material.dart';
import 'package:spell_checker/widgets/pop_up.dart';
import '../models/active_game_by_summoner.dart';
import 'search_screen.dart';
import 'package:spell_checker/widgets/profile.dart';
import 'package:spell_checker/widgets/game_length_timer.dart';
import 'package:spell_checker/widgets/participants_list.dart';
import 'package:get/get.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late Future<Participants> pars;

  String notFound = "Cannot found match.";
  String matchTypeError = "Game type error";
  String mapTypeError = "Only Summoner's Rift can be loaded";
  bool pressColor = false;
  bool pressText = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        primary: true,
        backgroundColor: Colors.grey.shade300,
        body: Center(
          child: FutureBuilder<Participants>(
            future: pars = fetchParticipants(
                encryptId: Get.parameters['param'].toString()),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                // case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasData) {
                    if (snapshot.data!.mapId == 11) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  Get.offAll(SearchSummoner(),
                                      transition:
                                          Transition.leftToRightWithFade);
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Profile(
                                  summonerNameFromMatch:
                                      Get.parameters['sumName'].toString(),
                                  profileIconIdFromMatch:
                                      Get.parameters['iconId'].toString(),
                                  summonerLevelFromMatch:
                                      Get.parameters['sumLevel'].toString()),
                              Column(
                                children: <Widget>[
                                  _matchType(snapshot.data!.mapId,
                                      snapshot.data!.queueType),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          pressColor ? Colors.blue : Colors.red,
                                    ),
                                    child: Text(pressText ? "????????????" : "????????? ??????"),
                                    onPressed: () {
                                      setState(() {
                                        pressColor = !pressColor;
                                        pressText = !pressText;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              GameLengthTimer(
                                  gameLengthFromMatch:
                                      snapshot.data!.gameLength.toString()),
                            ],
                          ),
                          Row(children: <Widget>[
                            Flexible(
                              child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      Divider(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (pressColor == false) {
                                      return Row(
                                        children: <Widget>[
                                          ParticipantsList(
                                              partsNamesFromMatch:
                                                  snapshot.data?.partsNames,
                                              spell1IdFromMatch:
                                                  snapshot.data?.spell1Id,
                                              spell1CoolDownFromMatch:
                                                  snapshot.data?.spell1CoolDown,
                                              spell2IdFromMatch:
                                                  snapshot.data?.spell2Id,
                                              spell2CoolDownFromMatch:
                                                  snapshot.data?.spell2CoolDown,
                                              championIdFromMatch:
                                                  snapshot.data?.championId,
                                              indexFromMatch: index,
                                              colorFromMatch:
                                                  Colors.blue.shade100),
                                          ParticipantsList(
                                              partsNamesFromMatch:
                                                  snapshot.data?.partsNames,
                                              spell1IdFromMatch:
                                                  snapshot.data?.spell1Id,
                                              spell1CoolDownFromMatch:
                                                  snapshot.data?.spell1CoolDown,
                                              spell2IdFromMatch:
                                                  snapshot.data?.spell2Id,
                                              spell2CoolDownFromMatch:
                                                  snapshot.data?.spell2CoolDown,
                                              championIdFromMatch:
                                                  snapshot.data?.championId,
                                              indexFromMatch: index + 5,
                                              colorFromMatch:
                                                  Colors.red.shade100),
                                        ],
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 350,
                                            child: ParticipantsList(
                                                partsNamesFromMatch:
                                                    snapshot.data!.partsNames,
                                                spell1IdFromMatch:
                                                    snapshot.data!.spell1Id,
                                                spell1CoolDownFromMatch:
                                                    snapshot
                                                        .data!.spell1CoolDown,
                                                spell2IdFromMatch:
                                                    snapshot.data!.spell2Id,
                                                spell2CoolDownFromMatch:
                                                    snapshot
                                                        .data!.spell2CoolDown,
                                                championIdFromMatch:
                                                    snapshot.data!.championId,
                                                indexFromMatch: index + 5,
                                                colorFromMatch:
                                                    Colors.red.shade100),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ])
                        ],
                      );
                    } else {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text(
                          mapTypeError,
                          maxLines: 2,
                          softWrap: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.off(() => SearchSummoner());
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    }
                  } else {
                    return AlertDialog(
                      title: Text("Error"),
                      content: Text(
                        notFound,
                        maxLines: 2,
                        softWrap: true,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.off(() => SearchSummoner());
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }

  _matchType(int mapId, int queueType) {
    if (queueType == 0) {
      return Text("Custom game");
    } else if (queueType == 420) {
      return Text("Solo queue");
    } else if (queueType == 430) {
      return Text("Normal game");
    } else if (queueType == 440) {
      return Text("Flex queue");
    } else {
      return alert(context, matchTypeError, 200);
    }
  }
}
