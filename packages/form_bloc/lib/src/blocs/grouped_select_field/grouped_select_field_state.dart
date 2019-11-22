import 'package:meta/meta.dart';
import 'package:quiver/core.dart';

import '../form/form_state.dart';
import '../field/field_bloc.dart';

class GroupedSelectFieldBlocState<GroupValue, Value> extends FieldBlocState<Value, Value> {
  final Map<GroupValue, List<Value>> grouped_items;

  GroupedSelectFieldBlocState({
    @required Value value,
    @required String error,
    @required bool isInitial,
    @required Suggestions<Value> suggestions,
    @required bool isValidated,
    @required bool isValidating,
    FormBlocState formBlocState,
    @required String toStringName,
    @required this.grouped_items,
  }) : super(
          value: value,
          error: error,
          isInitial: isInitial,
          suggestions: suggestions,
          isValidated: isValidated,
          isValidating: isValidating,
          formBlocState: formBlocState,
          toStringName: toStringName,
        );

  @override
  GroupedSelectFieldBlocState<GroupValue, Value> copyWith({
    Optional<Value> value,
    Optional<String> error,
    bool isInitial,
    Optional<Suggestions<Value>> suggestions,
    bool isValidated,
    bool isValidating,
    FormBlocState formBlocState,
    Optional<Map<GroupValue, List<Value>>> grouped_items,
  }) {
    return GroupedSelectFieldBlocState(
      value: value == null ? this.value : value.orNull,
      error: error == null ? this.error : error.orNull,
      isInitial: isInitial ?? this.isInitial,
      suggestions: suggestions == null ? this.suggestions : suggestions.orNull,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBlocState: formBlocState ?? this.formBlocState,
      toStringName: toStringName,
      grouped_items: grouped_items == null ? this.grouped_items : grouped_items.orNull,
    );
  }

  @override
  String toString() {
    String _toString = '';
    if (toStringName != null) {
      _toString += '${toStringName}';
    } else {
      _toString += '${runtimeType}';
    }
    _toString += ' {';
    _toString += ' value: ${value},';
    _toString += ' error: "${error}",';
    _toString += ' isInitial: $isInitial,';
    _toString += ' isValidated: ${isValidated},';
    _toString += ' isValidating: ${isValidating},';
    _toString += ' formBlocState: ${formBlocState},';
    _toString += ' grouped_items: $grouped_items,';
    _toString += ' }';

    return _toString;
  }

  @override
  List<Object> get props => [
        value,
        error,
        isInitial,
        suggestions,
        isValidated,
        isValidating,
        formBlocState,
        grouped_items,
      ];
}
