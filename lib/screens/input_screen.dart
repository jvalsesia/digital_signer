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
  late Uint8List fileBytesDocument = Uint8List(0);
  late Uint8List fileBytesSignature = Uint8List(0);
  late String documentFilePath = "";
  late String documentFileName = "";
  late String signatureFilePath = "";
  late String signatureFileName = "";
  late String signedDocumentLink = "";
  late String signedDocumentFilePath = "";
  late String accessToken = "";
  late String tokenExp = "";
  late bool isDocumentLoaded = false;
  late bool isSignatureLoaded = false;

  Future<void> setFileBytes(FileType fileType) async {
    var result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: fileType);
    if (result == null) {
      logger.i("No file selected");
    } else {
      final PlatformFile file = result.files.first;
      setState(() {
        if (fileType == FileType.any) {
          isDocumentLoaded = true;

          fileBytesDocument = file.bytes!;
        } else if (fileType == FileType.image) {
          isSignatureLoaded = true;
          fileBytesSignature = file.bytes!;
        }

        logger.w("Getting file using File Bytes");

        fileSize = file.size;
        logger.w("File size: $fileSize bytes");
      });
    }
  }

  Future<void> setDocumentPath() async {
    FileType fileType = FileType.any;
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
          isDocumentLoaded = true;
          logger.w("Getting file using File Path. Path: $documentFilePath");
        }
        fileSize = file.size;
        logger.w("File size: $fileSize bytes");
      });
    }
  }

  Future<void> setImagePath() async {
    FileType fileType = FileType.image;
    if (Platform.isAndroid) {
      fileType = FileType.any;
    }
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
          isSignatureLoaded = true;
          logger.w(
              "Getting signature using Image Path. Path: $signatureFilePath");
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

    String texto = "Digitally signed by BRY";
    dynamic data;
    if (kIsWeb) {
      data = await RestHandler().sendDocumentAsBytes(
          accessToken, fileBytesDocument, fileBytesSignature, texto);
      //var data = jsonDecode(signResponse);
    } else {
      data = await RestHandler().sendDocument(
          accessToken, documentFilePath, signatureFilePath, texto);
      //var data = jsonDecode(signResponse);
    }

    logger.w("$data");

    var link = data['documentos'][0]['links'][0]['href'];
    setState(() {
      signedDocumentLink = link;
    });

    logger.w(signedDocumentLink);
    var response = signedDocumentLink;

    if (!kIsWeb) {
      FileHandler fileHandler = FileHandler();
      var file = await fileHandler.loadPdfFromNetwork(response);

      setState(() {
        signedDocumentFilePath = file.path;
        response = signedDocumentFilePath;
      });
    }

    logger.w(response);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASSINATURA', style: kLargeButtonTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                                margin: const EdgeInsets.all(3.0),
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
                                            isDocumentLoaded ? "Ok" : "NENHUM",
                                            style: isDocumentLoaded
                                                ? kLabelTextStyleOk
                                                : kLabelTextStyleNotOk,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RoundIconButton(
                                      icon: FontAwesomeIcons.plus,
                                      onPressed: () {
                                        setState(() {
                                          if (kIsWeb) {
                                            setFileBytes(FileType.any);
                                          } else {
                                            setDocumentPath();
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
                                margin: const EdgeInsets.all(3.0),
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
                                            isSignatureLoaded
                                                ? "Ok"
                                                : "NENHUMA",
                                            style: isSignatureLoaded
                                                ? kLabelTextStyleOk
                                                : kLabelTextStyleNotOk,
                                          ),
                                        ],
                                      ),
                                    ),
                                    RoundIconButton(
                                      icon: FontAwesomeIcons.plus,
                                      onPressed: () {
                                        setState(() {
                                          if (kIsWeb) {
                                            setFileBytes(FileType.image);
                                          } else {
                                            setImagePath();
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
                signDocument().then((response) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            signedDocumentFilePath: response,
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
      ),
    );
  }
}
