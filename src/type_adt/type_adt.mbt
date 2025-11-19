///|
pub(all) enum Type {
  Basic(String)
  Generic(String)
  Tuple(Array[Type])
  Function(Type, Type)
  Constructor(String, Type)
}

///|
pub impl Show for Type with to_string(s) {
  match s {
    Basic(s) => s
    Generic(s) => "\{s}ᴳ"
    Tuple(s) => {
      let content = s.map(Show::to_string).join(", ")
      "(\{content})"
    }
    Function(s, t) => "\{s} -> \{t}"
    Constructor(s, t) => "\{s}<\{t}>"
  }
}

///|
pub impl Show for Type with output(s, l) {
  l.write_string(s.to_string())
}

///|
pub fn array_eq(
  a : Array[Type],
  b : Array[Type],
  f : (Type, Type) -> Bool,
) -> Bool {
  if a.length() != b.length() {
    return false
  }
  let mut res = true
  a.eachi((i, s_t) => if !f(s_t, b[i]) { res = false })
  return res
}
