import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

fn f_core(s: String, str_a_len: Int) -> Int {
  let start = s |> string.drop_end(str_a_len / 2)
  let end = s |> string.drop_start(str_a_len / 2)
  case start == end {
    True ->
      case int.parse(s) {
        Ok(i) -> i
        Error(_) -> 0
      }
    False -> 0
  }
}

fn f_two_rep(a: Int, b: Int, sum: Int) -> Int {
  case a > b {
    True -> sum
    False -> {
      let str_a = int.to_string(a)
      let str_a_len = string.length(str_a)
      case str_a_len % 2 == 0 {
        True -> {
          let value = f_core(str_a, str_a_len)
          f_two_rep(a + 1, b, sum + value)
        }
        False -> {
          f_two_rep(a + 1, b, sum)
        }
      }
    }
  }
}

fn calcola_val(s: String) -> Int {
  let parts = string.split(s, "-")

  let res = list.map(parts, fn(part) { int.parse(part) })

  case res {
    [Ok(a), Ok(b)] -> {
      f_two_rep(a, b, 0)
    }
    _ -> 0
  }
}

pub fn main() {
  case simplifile.read("righe.txt") {
    Error(_) -> io.println("Errore: non trovo righe.txt")
    Ok(content) -> {
      let lines = string.split(content, ",")
      io.println(
        int.to_string(
          list.fold(lines, 0, fn(sum, line) { sum + calcola_val(line) }),
        ),
      )
    }
  }
}
