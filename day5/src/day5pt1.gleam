import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type Range {
  Range(start: Int, end: Int)
}

pub fn parse_input(input: String) -> #(List(Range), List(Int)) {
  let parts = string.split(input, on: "\n\n")

  case parts {
    [ranges_str, ids_str] -> {
      let ranges = parse_ranges(ranges_str)
      let ids = parse_ids(ids_str)
      #(ranges, ids)
    }
    _ -> #([], [])
  }
}

fn parse_ranges(input: String) -> List(Range) {
  input
  |> string.split("\n")
  |> list.filter(fn(line) { line != "" })
  |> list.filter_map(parse_range)
}

fn parse_range(line: String) -> Result(Range, Nil) {
  case string.split(line, on: "-") {
    [start_str, end_str] -> {
      use start <- result.try(int.parse(start_str))
      use end <- result.try(int.parse(end_str))
      Ok(Range(start, end))
    }
    _ -> Error(Nil)
  }
}

fn parse_ids(input: String) -> List(Int) {
  input
  |> string.split("\n")
  |> list.filter(fn(line) { line != "" })
  |> list.filter_map(int.parse)
}

pub fn is_fresh(id: Int, ranges: List(Range)) -> Bool {
  list.any(ranges, fn(range) { id >= range.start && id <= range.end })
}

pub fn count_fresh(ranges: List(Range), ids: List(Int)) -> Int {
  ids
  |> list.filter(fn(id) { is_fresh(id, ranges) })
  |> list.length
}

pub fn solve(input: String) -> Int {
  let #(ranges, ids) = parse_input(input)
  count_fresh(ranges, ids)
}

pub fn main() {
  let in =
    "3-5
10-14
16-20
12-18

1
5
8
11
17
32
"

  let result = solve(in)
  io.println("result: " <> int.to_string(result))
}
