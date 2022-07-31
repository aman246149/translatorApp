part of 'translation_bloc.dart';

@immutable
abstract class TranslationEvent {}



class TranslateDataEvent extends TranslationEvent{
  final String text;
  final List<String> to;

  TranslateDataEvent({required this.text, required this.to});

}