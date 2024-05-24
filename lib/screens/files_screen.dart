import 'dart:io';

import 'package:digital_signer/screens/input_screen.dart';
import 'package:digital_signer/utils/constants.dart';
import 'package:digital_signer/utils/icon_content.dart';
import 'package:digital_signer/utils/log.dart';
import 'package:digital_signer/utils/reusable_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  late String directory;
  late List<FileSystemEntity> files = List.empty();

  late String selectedFile = "";
  late String selectedFileName = "";
  late int selectedIndex = 0;

  void _listofFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    logger.d(directory);
    setState(() {
      files = Directory("$directory/").listSync();
      logger.d(files.length);
    });
  }

  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DOCUMENTOS', style: kLargeButtonTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (BuildContext context, int index) {
                    var info = files[index].uri.pathSegments.last;
                    return ListTile(
                      tileColor: selectedIndex == index
                          ? kActiveCardColor
                          : kInactiveCardColor,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const IconContent(
                              widgetIcon: FontAwesomeIcons.filePdf,
                              label: "",
                              foregroundContainerColor:
                                  kForegroundContainerColor,
                              iconSize: 50.0,
                            ),
                            Text(
                              info,
                              style: kLabelTextStyle,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            ReusableCard(
              cardColor: kActiveCardColor,
              cardChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    files.isEmpty
                        ? "Nenhum documento encontrado"
                        : files[selectedIndex].uri.pathSegments.last,
                    style: kLabelTextStyle,
                  ),
                ],
              ),
              onPress: () {
                setState(() {});
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    //color: kBottomContainerColor,
                    //margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      color: kBottomContainerColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: double.infinity,
                    height: kBottomContainerHeight,
                    child: const Center(
                      child: Text('SELECIONAR', style: kLargeButtonTextStyle),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
