func unreachable {.noReturn, inline.} = discard

template scope*(body: untyped): untyped =
  if true: # https://github.com/nim-lang/Nim/pull/20785
    body
  else:
    unreachable()

template asLet*(value, name, body: untyped): untyped =
  scope:
    let name = value
    body
    name

template asVar*(value, name, body: untyped): untyped =
  scope:
    var name = value
    body
    name

template viaVar*[T](t: typedesc[T]; name, body: untyped): T =
  scope:
    var name: T
    body
    name
