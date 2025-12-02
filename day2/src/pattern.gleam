import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

fn is_repeating_pattern(s: String) -> Bool {
  let len = string.length(s)

  // Try all possible pattern lengths from 1 to len/2
  list.any(list.range(1, len / 2), fn(pattern_len) {
    // Check if the length is divisible by pattern_len
    case len % pattern_len == 0 {
      False -> False
      True -> {
        let pattern = string.slice(s, 0, pattern_len)
        let repetitions = len / pattern_len

        // Check if pattern repeats at least twice and forms the whole string
        case repetitions >= 2 {
          False -> False
          True -> {
            // Build the repeated pattern and compare
            let repeated =
              list.fold(list.range(1, repetitions), "", fn(acc, _) {
                acc <> pattern
              })
            repeated == s
          }
        }
      }
    }
  })
}

fn sum_invalid_in_interval(a: Int, b: Int, sum: Int) -> Int {
  case a > b {
    True -> sum
    False -> {
      let str_a = int.to_string(a)
      case is_repeating_pattern(str_a) {
        True -> sum_invalid_in_interval(a + 1, b, sum + a)
        False -> sum_invalid_in_interval(a + 1, b, sum)
      }
    }
  }
}

fn calcola_val(s: String) -> Int {
  let parts = string.split(s, "-")
  let res = list.map(parts, fn(part) { int.parse(part) })

  case res {
    [Ok(a), Ok(b)] -> sum_invalid_in_interval(a, b, 0)
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
