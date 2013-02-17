class Visibility {
  final static int EXPANDED  = 1;
  final static int COLLAPSED = 2;
  final static int PARTIAL   = 3;
  final static int NONE      = 4;
  int v;
  Visibility(int v) { this.v = v; }
}

class Modes {
  final static int PACK   = 1;
  final static int COLUMN = 2;
  final static int ROW    = 3;
  int m;
  Modes(int m) { this.m = m; }
}

