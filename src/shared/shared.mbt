///|
pub fn eq(a : Type, b : Type) -> Bool {
  match a {
    Function(s_x, s_y) =>
      if b is Function(o_x, o_y) {
        eq(s_x, o_x) && eq(s_y, o_y)
      } else {
        false
      }
    Tuple(s) => if b is Tuple(o) { ... } else { false }
    Generic(s) => if b is Generic(o) { s == o } else { false }
    Basic(s) => if b is Basic(o) { s == o } else { false }
    Constructor(s_n, s_t) =>
      if b is Constructor(o_n, o_t) {
        s_n == o_n && eq(s_t, o_t)
      } else {
        false
      }
  }
}

///|
fn generic_distribution(arr_types : Array[Type]) -> Map[String, Set[Int]] {
  let name = []
  let res : Map[String, Set[Int]] = Map::new()
  arr_types.eachi((i, t) => match t {
    Generic(s) =>
      if name.search(s) is Some(_) {
        res[s].add(i)
      } else {
        let j = name.length()
        name.push(s)
        res[s] = Set::new()
        res[s].add(i)
      }
    _ => ()
  })
  res
}
