part of 'translation_bloc.dart';

@immutable
abstract class TranslationState {}

class TranslationInitial extends TranslationState {}

class TranslationLoadingState extends TranslationState {}

class TranslationErrorState extends TranslationState {
  final String message;

  TranslationErrorState({required this.message});
}

class TranslationSuccessState extends TranslationState {
  final String list;

  TranslationSuccessState({required this.list});

}
