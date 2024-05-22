import 'dart:io';

import 'package:digital_signer/handlers/file_handler.dart';
import 'package:digital_signer/handlers/rest_handler.dart';
import 'package:digital_signer/handlers/token_handler.dart';
import 'package:digital_signer/screens/result_screen.dart';
import 'package:digital_signer/utils/constants.dart';
import 'package:digital_signer/utils/icon_content.dart';
import 'package:digital_signer/utils/log.dart';
import 'package:digital_signer/utils/reusable_card.dart';
import 'package:digital_signer/utils/round_icon_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  late int fileSize = 0;
  late Uint8List fileBytes = Uint8List(0);
  late String documentFilePath = "";
  late String documentFileName = "";
  late String signatureFilePath = "";
  late String signatureFileName = "";
  late String signedDocumentLink = "";
  late String signedDocumentFilePath = "";
  late String accessToken = "";
  late String tokenExp = "";

  Future<void> setDocumentPathAndBytes(FileType fileType) async {
    var result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: fileType);
    if (result == null) {
      logger.i("No file selected");
    } else {
      final PlatformFile file = result.files.first;
      setState(() {
        if (!kIsWeb) {
          documentFilePath = file.path!;
          documentFileName = file.name;
          logger.w("Getting file using File Path. Path: $documentFilePath");
        } else {
          fileBytes = file.bytes!;
          logger.w("Getting file using File Bytes");
        }
        fileSize = file.size;
        logger.w("File size: $fileSize bytes");
      });
    }
  }

  Future<void> setImagePathAndBytes(FileType fileType) async {
    var result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: fileType);
    if (result == null) {
      logger.i("No file selected");
    } else {
      final PlatformFile file = result.files.first;
      setState(() {
        if (!kIsWeb) {
          signatureFilePath = file.path!;
          signatureFileName = file.name;
          logger.w(
              "Getting signature using Image Path. Path: $signatureFilePath");
        } else {
          fileBytes = file.bytes!;
          logger.w("Getting file using File Bytes");
        }
        fileSize = file.size;
        logger.w("File size: $fileSize bytes");
      });
    }
  }

  Future<void> getAccessToken() async {
    final accessToken = await TokenHandler().getAccessToken();
    final tokenExp = await TokenHandler().getTokenExpirationDate(accessToken);

    setState(() {
      this.accessToken = accessToken;
      this.tokenExp = tokenExp;
    });
  }

  Future<String> signDocument() async {
    await getAccessToken();
    String documentPath = documentFilePath;
    String imagePath = signatureFilePath;
    String texto = "Digitally signed by BRY";
    final data = await RestHandler()
        .sendDocument(accessToken, documentPath, imagePath, texto);
    //var data = jsonDecode(signResponse);
    logger.w("$data");

    var link = data['documentos'][0]['links'][0]['href'];
    setState(() {
      signedDocumentLink = link;
    });

    logger.w(signedDocumentLink);
    FileHandler fileHandler = FileHandler();
    var file = await fileHandler.loadPdfFromNetwork(signedDocumentLink);

    setState(() {
      signedDocumentFilePath = file.path;
    });

    logger.w(signedDocumentFilePath);
    return signedDocumentFilePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASSINATURA', style: kLargeButtonTextStyle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ReusableCard(
                    cardColor: kInactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const IconContent(
                          widgetIcon: FontAwesomeIcons.file,
                          label: "DOCUMENTO",
                          foregroundContainerColor: kForegroundContainerColor,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: kButtonContainerColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text(
                                          "Adicionar documento",
                                          style: kLabelTextStyle,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          documentFileName == ""
                                              ? "NENHUMA"
                                              : "OK",
                                          style: documentFileName == ""
                                              ? kLabelTextStyleNotOk
                                              : kLabelTextStyleOk,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    onPressed: () {
                                      setState(() {
                                        setDocumentPathAndBytes(FileType.any);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onPress: () {
                      setState(() async {});
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ReusableCard(
                    cardColor: kInactiveCardColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const IconContent(
                          widgetIcon: FontAwesomeIcons.signature,
                          label: "ASSINATURA",
                          foregroundContainerColor: kForegroundContainerColor,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: kButtonContainerColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Adicionar assinatura",
                                          style: kLabelTextStyle,
                                        ),
                                        Text(
                                          signatureFileName == ""
                                              ? "NENHUMA"
                                              : "OK",
                                          style: signatureFileName == ""
                                              ? kLabelTextStyleNotOk
                                              : kLabelTextStyleOk,
                                        ),
                                      ],
                                    ),
                                  ),
                                  RoundIconButton(
                                    icon: FontAwesomeIcons.plus,
                                    onPressed: () {
                                      setState(() {
                                        if (Platform.isAndroid) {
                                          setImagePathAndBytes(FileType.any);
                                        } else {
                                          setImagePathAndBytes(FileType.image);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onPress: () {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              signDocument().then((value) => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(
                          signedDocumentFilePath: value,
                        ),
                      ),
                    )
                  });
            },
            child: Column(
              children: [
                Container(
                  //color: kBottomContainerColor,
                  margin: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    color: kBottomContainerColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: double.infinity,
                  height: kBottomContainerHeight,
                  child: const Center(
                    child: Text('ASSINAR', style: kLargeButtonTextStyle),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
