class Initializer {
  final List<Initializable> _initializes;

  Initializer(
    List<Initializable> initializes,
  ) : _initializes = initializes;

  Future<void> initialize() async {
    for (final initial in _initializes) {
      await initial.initialize();
    }
  }
}

abstract class Initializable {
  // initialize process
  Future<void> initialize();
}
