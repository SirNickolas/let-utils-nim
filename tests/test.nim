import std/unittest
import letUtils

test "`scope` works":
  scope:
    let a = 1
    scope:
      let a = 2
      check a == 2
    check a == 1
  check: not declared a

test "`asLet` works":
  let a = (let b = 1; b).asLet c:
    check: not declared a
    check b == 1
    check c == 1
  check a == 1
  check b == 1
  check: not declared c

test "`asLet` without UFCS works":
  let a = asLet((let b = 1; b), c):
    check: not declared a
    check b == 1
    check c == 1
  check a == 1
  check: not declared b # Different from the test above!
  check: not declared c

test "`asVar` works":
  let a = (let b = 1; b).asVar c:
    check: not declared a
    check b == 1
    check c == 1
    c = 2
  check a == 2
  check b == 1
  check: not declared c

test "`asVar` without UFCS works":
  let a = asVar((let b = 1; b), c):
    check: not declared a
    check b == 1
    check c == 1
    c = 2
  check a == 2
  check: not declared b # Different from the test above!
  check: not declared c

test "`viaVar` works":
  #[
    Declaring identifiers in a statement-list expression that yields a `typedesc` is quirky.
    It differs across Nim versions and can produce errors in the generated C code (even though
    type-checking succeeds) so we don't test it. Please don't do that either.
  ]#
  let a = seq[string].viaVar b:
    b &= "msg"
    check: not declared a
    check b == ["msg"]
  check a == ["msg"]
  check: not declared b

test "`viaVar` without UFCS works":
  let a = viaVar(seq[string], b):
    b &= "msg"
    check: not declared a
    check b == ["msg"]
  check a == ["msg"]
  check: not declared b
