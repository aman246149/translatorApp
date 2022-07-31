import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation/app/view/bloc/translation_bloc.dart';

import '../../../global/languages.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({Key? key}) : super(key: key);

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  bool toggleswitch = false;

  List<String> languagesCode = ["es", "fr", "ja", "zh", "ko"];
  List<String> languageslist = [
    "Spanish",
    "French",
    "Japanese",
    "Chinese",
    "Korean"
  ];
  String _selectedLanguage = "";
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
        toggleswitch = false;
      }
    } else {
      setState(() => _isListening = false);
      toggleswitch = true;
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PingoLearn Round-1"),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
        onPressed: () {
          setState(() {
            _listen();
          });
        },
        // ignore: sort_child_properties_last
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        tooltip: 'Listen',
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 0, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 150,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(_text),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
            ),
            Visibility(
              visible: toggleswitch,
              child: DropdownButton(
                hint: const Text('Please choose a language'),
                value: _selectedLanguage.isEmpty ? null : _selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                    List<String> langList = chooseLanguage(_selectedLanguage);
                    BlocProvider.of<TranslationBloc>(context)
                        .add(TranslateDataEvent(text: _text, to: langList));
                  });
                },
                items: languageslist.map((language) {
                  return DropdownMenuItem(
                    child: Text(language),
                    value: language,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              visible: _selectedLanguage.isNotEmpty && toggleswitch == true,
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, right: 28),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  child: Center(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Translation",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SingleChildScrollView(
                          child: BlocBuilder<TranslationBloc, TranslationState>(
                        builder: (context, state) {
                          if (state is TranslationLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is TranslationErrorState) {
                            return Center(
                              child: Text(state.message),
                            );
                          }

                          if (state is TranslationSuccessState) {
                            return Text(state.list);
                          }
                          return Container();
                        },
                      )),
                    ],
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
