import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:meta/meta.dart';
import 'package:translation/app/data/tanslation_api.dart';
import 'package:translation/app/model/translation_model.dart';

part 'translation_event.dart';
part 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  TranslationBloc() : super(TranslationInitial()) {
    on<TranslationEvent>((event, emit) {});

    on<TranslateDataEvent>((event, emit) async {
      emit(TranslationLoadingState());

      final response = await TranslationApi.convertText(event.text, event.to);

      response.fold(
          (left) => emit(TranslationErrorState(message: left.message)),
          (right) => emit(TranslationSuccessState(list: right)));
    });
  }
}
