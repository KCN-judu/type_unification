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
fn generic_distribution(arr_types : Array[Type]) -> Map[Int, Set[Int]] {
  let name = []
  let res : Map[Int, Set[Int]] = Map::new()
  arr_types.eachi((i, t) => match t {
    Generic(s) =>
      if name.search(s) is Some(j) {
        res[j].add(i)
      } else {
        let j = name.length()
        name.push(s)
        res[j] = Set::new()
        res[j].add(i)
      }
    _ => ()
  })
  res
}

///|
fn subst_generic_vertical(t : Type, g : String, o : Type) -> Type {
  match o {
    Generic(s) => if s == g { t } else { o }
    Tuple(_) => subst_generic_horizontal(t, g, o)
    Function(x, y) => {
      let x = subst_generic_vertical(t, g, x)
      let y = subst_generic_vertical(t, g, y)
      Function(x, y)
    }
    Constructor(s_n, s_t) => {
      let s_t = subst_generic_vertical(t, g, s_t)
      Constructor(s_n, s_t)
    }
    Basic(_) => o
  }
}

///|
fn subst_generic_horizontal(t : Type, g : String, o : Type) -> Type {
  guard o is Tuple(arr_types)
  let res = arr_types.copy()
  for i in 0..<arr_types.length() {
    match arr_types[i] {
      Generic(gi) => if gi == g { res[i] = t }
      _ => res[i] = subst_generic_vertical(t, g, res[i])
    }
  }
  Tuple(res)
}

///|
pub impl Eq for Type with equal(s, o) {
  match s {
    Function(s_x, s_y) =>
      if o is Function(o_x, o_y) {
        s_x == o_x && s_y == o_y
      } else {
        false
      }
    Tuple(s) =>
      if o is Tuple(o) {
        s.length() == o.length() &&
        generic_distribution(s) == generic_distribution(o)
      } else {
        false
      }
    Generic(_) => o is Generic(_)
    Basic(s) => if o is Basic(o) { s == o } else { false }
    Constructor(s_n, s_t) =>
      if o is Constructor(o_n, o_t) {
        s_n == o_n && s_t == o_t
      } else {
        false
      }
  }
}

///|
pub fn unification(t1 : Type, t2 : Type) -> Type? {
  match (t1, t2) {
    (Generic(_), Generic(_)) => Some(Generic("T"))
    (Generic(_), _) => Some(t2)
    (_, Generic(_)) => Some(t1)
    (Basic(s1), Basic(s2)) => if s1 == s2 { Some(t1) } else { None }
    (Constructor(sn1, st1), Constructor(sn2, st2)) =>
      if sn1 == sn2 {
        if unification(st1, st2) is Some(u) {
          Some(Constructor(sn1, u))
        } else {
          return None
        }
      } else {
        None
      }
    (Function(x1, y1), Function(x2, y2)) => {
      let x = unification(x1, x2)
      let y = unification(y1, y2)
      if x is Some(ux) && y is Some(uy) {
        Some(Function(ux, uy))
      } else {
        None
      }
    }
    (Tuple(a), Tuple(b)) =>
      if a.length() != b.length() {
        None
      } else {
        let a_subst = a.copy()
        let b_subst = b.copy()
        for i in 0..<a.length() {
          if a[i] is Generic(ga) && !(b[i] is Generic(_)) {
            for j in 0..<a.length() {
              a_subst[j] = subst_generic_vertical(b[i], ga, a_subst[j])
            }
          } else if b[i] is Generic(gb) && !(a[i] is Generic(_)) {
            for j in 0..<a.length() {
              b_subst[j] = subst_generic_vertical(a[i], gb, b_subst[j])
            }
          } else if a[i] != b[i] {
            return None
          }
        }
        if a_subst == b_subst {
          Some(Tuple(a_subst))
        } else {
          None
        }
      }
    _ => None
  }
}

///|
test {
  let a = Constructor("List", int)
  let b = Constructor("List", double)
  let c = Constructor("Array", Tuple([int, Generic("T")]))
  let d = Constructor("Array", Tuple([int, Generic("A")]))
  let e = Generic("T")
  let f = Generic("A")
  let g = Tuple([e, e, f, f, f])
  let h = Tuple([f, f, e, e, e])
  let ua = Constructor(
    "List",
    Tuple([Generic("T"), Generic("T"), int, int, int]),
  )
  let ub = Constructor(
    "List",
    Tuple([double, double, Generic("A"), Generic("A"), Generic("A")]),
  )
  let uc = Constructor(
    "List",
    Tuple([Generic("T"), Generic("T"), Generic("T"), Generic("T"), Generic("T")]),
  )
  let ud = Constructor("List", Tuple([double, double, int, int, int]))
  inspect(content="false", a == b)
  inspect(content="true", c == d)
  inspect(content="true", e == f)
  inspect(content="true", g == h)
  inspect(
    content="Some(List<(Double, Double, Int, Int, Int)>)",
    unification(ua, ub),
  )
  inspect(content="None", unification(uc, ud))
}
