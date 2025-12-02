import gleam/int
import gleam/io
import gleam/result
import gleam/string
import simplifile

fn step(pos: Int, right: Bool) -> #(Int, Bool) {
  let new_pos = case right {
    True ->
      case pos + 1 > 99 {
        True -> 0
        False -> pos + 1
      }
    False ->
      case pos - 1 < 0 {
        True -> 99
        False -> pos - 1
      }
  }
  #(new_pos, new_pos == 0)
}

fn walk(pos: Int, steps: Int, right: Bool) -> #(Int, Int) {
  case steps {
    0 -> #(pos, 0)
    _ -> {
      let #(new_pos, crossed_zero) = step(pos, right)
      let #(final_pos, total_crosses) = walk(new_pos, steps - 1, right)
      #(
        final_pos,
        total_crosses
          + case crossed_zero {
          True -> 1
          False -> 0
        },
      )
    }
  }
}

fn parse_line(line: String) -> Result(#(Bool, Int), Nil) {
  case line {
    "R" <> num -> int.parse(num) |> result.map(fn(n) { #(True, n) })
    "L" <> num -> int.parse(num) |> result.map(fn(n) { #(False, n) })
    _ -> Error(Nil)
  }
}

fn process_lines(lines: List(String), pos: Int, total: Int) -> Int {
  case lines {
    [] -> total
    [line, ..rest] ->
      case parse_line(line) {
        Ok(#(right, steps)) -> {
          let #(new_pos, crosses) = walk(pos, steps, right)
          process_lines(rest, new_pos, total + crosses)
        }
        Error(_) -> process_lines(rest, pos, total)
      }
  }
}

pub fn main() {
  case simplifile.read("righe.txt") {
    Error(_) -> io.println("Errore: non trovo righe.txt")
    Ok(content) -> {
      let lines = string.split(content, "\n")
      let result = process_lines(lines, 50, 0)
      io.println("La soluzione Part 2 è " <> int.to_string(result))
    }
  }
}
