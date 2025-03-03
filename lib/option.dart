sealed class Option<T> {
  const Option();

  R when<R>({
    required R Function(T value) some,
    required R Function() none,
  });

  bool get isSome => this is Some<T>;
  bool get isNone => this is None<T>;

  Option<R> map<R>(R Function(T value) transform) {
    return when(
      some: (value) => Some(transform(value)),
      none: () => None<R>(),
    );
  }

  Option<R> flatMap<R>(Option<R> Function(T value) transform) {
    return when(
      some: (value) => transform(value),
      none: () => None<R>(),
    );
  }

  T orElse(T Function() defaultValue) {
    return when(
      some: (value) => value,
      none: () => defaultValue(),
    );
  }

  Option<T> getOrElse(T Function() defaultValue) {
    return when(
      some: (value) => this,
      none: () => Some(defaultValue()),
    );
  }

  T? get() {
    return when(
      some: (value) => value,
      none: () => null,
    );
  }
}

class Some<T> extends Option<T> {
  final T value;
  const Some(this.value);

  @override
  R when<R>({
    required R Function(T value) some,
    required R Function() none,
  }) => some(value);
}

class None<T> extends Option<T> {
  const None();

  @override
  R when<R>({
    required R Function(T value) some,
    required R Function() none,
  }) => none();
}
