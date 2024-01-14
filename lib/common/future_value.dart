abstract class FutureValue<TValue> {}

class ValuePending<TValue> extends FutureValue<TValue> {}

class ValueRunning<TValue> extends FutureValue<TValue> {
  ValueRunning({this.startedAt});

  final DateTime? startedAt;
}

class ValueFinished<TValue> extends FutureValue<TValue> {
  ValueFinished({this.value, this.startedAt, this.timeSpan});

  final TValue? value;
  final DateTime? startedAt;
  final Duration? timeSpan;
}

abstract class ValueFailed<TValue> extends FutureValue<TValue> {}

class ValueTimedOut<TValue> extends ValueFailed<TValue> {
  ValueTimedOut({this.duration});

  final Duration? duration;
}

class ValueError<TValue> extends ValueFailed<TValue> {
  ValueError({this.error, this.stackTrace});

  final Object? error;
  final StackTrace? stackTrace;
}
