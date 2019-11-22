part of '../field/field_bloc.dart';

/// A `FieldBloc` used to select one item from a grouped set
/// from multiple items.
class GroupedSelectFieldBloc<GroupValue, Value>
    extends FieldBlocBase<Value, Value, GroupedSelectFieldBlocState<GroupValue, Value>> {
  final Map<GroupValue, List<Value>> _grouped_items;

  /// ### Properties:
  ///
  /// * [initialValue] : The initial value of the field,
  /// by default is `null`.
  /// * [validators] : List of [Validator]s.
  /// Each time the `value` will change,
  /// if the [FormBloc] that use this [SelectFieldBloc] has set
  /// in the `super` constructor `autoValidate = true`,
  /// the `value` is passed to each `validator`,
  /// and if any `validator` returns a `String error`,
  /// it will be added to [SelectFieldBlocState.error].
  /// Else if `autoValidate = false`, the value will be checked only
  /// when you call [validate] which is called automatically when call [FormBloc.submit].
  /// * [asyncValidators] : List of [AsyncValidator]s.
  /// it is the same as [validators] but asynchronous.
  /// Very useful for server validation.
  /// * [asyncValidatorDebounceTime] : The debounce time when any `asyncValidator`
  /// must be called, by default is 500 milliseconds.
  /// Very useful for reduce the number of invocations of each `asyncValidator.
  /// For example, used for prevent limit in API calls.
  /// * [suggestions] : This need be a [Suggestions] and will be
  /// added to [SelectFieldBlocState.suggestions].
  /// It is used to suggest values, usually from an API,
  /// and any of those suggestions can be used to update
  /// the value using [updateValue].
  /// * [toStringName] : This will be added to [SelectFieldBlocState.toStringName].
  /// * [items] : The list of items that can be selected to update the value.
  GroupedSelectFieldBloc({
    Value initialValue,
    List<Validator<Value>> validators,
    List<AsyncValidator<Value>> asyncValidators,
    Duration asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<Value> suggestions,
    String toStringName,
    Map<GroupValue, List<Value>> items,
  })  : assert(asyncValidatorDebounceTime != null),
        _grouped_items = items ?? Map(),
        super(
          initialValue,
          validators,
          asyncValidators,
          asyncValidatorDebounceTime,
          suggestions,
          toStringName,
        );

  @override
  GroupedSelectFieldBlocState<GroupValue, Value> get initialState => GroupedSelectFieldBlocState(
        value: _initialValue,
        error: _getInitialStateError,
        isInitial: true,
        suggestions: _suggestions,
        isValidated: _isValidated(_getInitialStateIsValidating),
        isValidating: _getInitialStateIsValidating,
        toStringName: _toStringName,
        grouped_items: _grouped_items,
      );

  /// Set [items] to the `items` of the current state.
  ///
  /// If you want to add or remove elements to `items`
  /// of the current state,
  /// use [addItem] or [removeItem].
  void updateItems(Map<GroupValue, List<Value>> grouped_items) => add(UpdateFieldBlocGroupedItems(grouped_items));

  /// Add [item] to the current `items`
  /// of the current state.
  void addItem(GroupValue group, Value item) => add(AddFieldBlocGroupedItem(group, item));

  /// Remove [item] to the current `items`
  /// of the current state.
  void removeItem(Value item) => add(RemoveFieldBlocItem(item));

  @override
  Stream<GroupedSelectFieldBlocState<GroupValue, Value>> _mapCustomEventToState(
    FieldBlocEvent event,
  ) async* {
    if (event is UpdateFieldBlocGroupedItems<GroupValue, Value>) {
      yield state.copyWith(
        grouped_items: Optional.fromNullable(event.grouped_items)
      );
    } else if (event is AddFieldBlocGroupedItem<GroupValue, Value>) {
      Map<GroupValue, List<Value>> grouped_items = state.grouped_items ?? Map<GroupValue, List<Value>>();
      Map<GroupValue, List<Value>> result = new Map();
      grouped_items.forEach((key, value) {
        List<Value> resolved = List<Value>.from(value);
        if (key == event.group)
          resolved.add(event.item);
        result[key] = resolved;
      });
      yield state.copyWith(
        grouped_items: Optional.fromNullable(result),
      );
    } else if (event is RemoveFieldBlocItem<Value>) {
      Map<GroupValue, List<Value>> grouped_items = state.grouped_items;
      if (grouped_items != null && grouped_items.isNotEmpty) {
        Map<GroupValue, List<Value>> result = new Map();
        grouped_items.forEach((key, value) {
          result[key] = List<Value>.from(value)..remove(event.item);
        });
        yield state.copyWith(
          grouped_items: Optional.fromNullable(result)
        );
      }
    }
  }
}
