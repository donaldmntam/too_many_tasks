Never badTransition(Object? state, String transition) {
  throw "Bad transition detected! Transition of '${transition}' happened when "
    "the state was '${state}'!";
}