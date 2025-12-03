////--- Day 3: Lobby --- 
////  You descend a short staircase, enter the surprisingly vast lobby, and are quickly cleared by the security checkpoint. When you get to the main elevators, however, you discover that each one has a red light above it: they're all offline.
////  
////  "Sorry about that," an Elf apologizes as she tinkers with a nearby control panel. "Some kind of electrical surge seems to have fried them. I'll try to get them online soon."
////  
////  You explain your need to get further underground. "Well, you could at least take the escalator down to the printing department, not that you'd get much further than that without the elevators working. That is, you could if the escalator weren't also offline."
////  
////  "But, don't worry! It's not fried; it just needs power. Maybe you can get it running while I keep working on the elevators."
////  
////  There are batteries nearby that can supply emergency power to the escalator for just such an occasion. The batteries are each labeled with their joltage rating, a value from 1 to 9. You make a note of their joltage ratings (your puzzle input). For example:
////  
////  987654321111111
////  811111111111119
////  234234234234278
////  818181911112111
////  The batteries are arranged into banks; each line of digits in your input corresponds to a single bank of batteries. Within each bank, you need to turn on exactly two batteries; the joltage that the bank produces is equal to the number formed by the digits on the batteries you've turned on. For example, if you have a bank like 12345 and you turn on batteries 2 and 4, the bank would produce 24 jolts. (You cannot rearrange batteries.)
////  
////  You'll need to find the largest possible joltage each bank can produce. In the above example:
////  
////  In 987654321111111, you can make the largest joltage possible, 98, by turning on the first two batteries.
////  In 811111111111119, you can make the largest joltage possible by turning on the batteries labeled 8 and 9, producing 89 jolts.
////  In 234234234234278, you can make 78 by turning on the last two batteries (marked 7 and 8).
////  In 818181911112111, the largest joltage you can produce is 92.
////  The total output joltage is the sum of the maximum joltage from each bank, so in this example, the total output joltage is 98 + 89 + 78 + 92 = 357.
////  
////  There are many batteries in front of you. Find the maximum joltage possible from each bank; what is the total output joltage?

import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

fn unisci_e_somma(cifre: List(Int)) -> Int {
  cifre
  |> list.sized_chunk(2)
  |> list.map(fn(coppia) {
    case coppia {
      [a, b] -> a * 10 + b
      [a] -> a
      _ -> 0
    }
  })
  |> list.fold(0, fn(acc, n) { acc + n })
  // Somma tutti i numeri
}

fn pollo(l) {
  case list.max(l, int.compare) {
    Ok(max_value) -> {
      list.drop_while(l, fn(x) { x != max_value })
    }
    Error(Nil) -> {
      []
    }
  }
}

/// Processes each line (battery bank) to find the maximum joltage.
/// For each bank, this function:
/// 1. Removes the newline character
/// 2. Splits into individual digit characters
/// 3. Parses digits to integers
/// 4. pollomoment
/// 5. Forms the joltage number and prints it
/// 
/// # Parameters
/// - lines: List of strings, each representing a battery bank
fn f(lines) {
  list.map(lines, fn(x) {
    // Remove trailing newline character and save it
    let removed_char = string.drop_start(x, 99)

    let result =
      string.drop_end(x, 1)
      // Split string into individual characters
      |> string.split("")
      // Parse each character to integer, filtering out non-digits
      |> list.filter_map(int.parse)
      // Find the second-largest digit (since we want the two largest)
      |> pollo

    // Append the removed character (converted to int if possible)
    case int.parse(removed_char) {
      Ok(num) -> list.append(result, [num])
      Error(_) -> result
    }
  })
}

fn f2(lines) {
  list.map(lines, fn(x) {
    let first = list.first(x) |> result.unwrap(0)
    // Prendi il primo elemento
    let max_rest =
      x
      |> list.drop(1)
      |> list.max(int.compare)
      |> result.unwrap(0)
    // Il max restituisce un Result

    [first, max_rest]
    // Restituisci entrambi i numeri
  })
  |> list.flatten
  // Appiattisci per avere una lista unica
}

/// Main entry point of the program.
/// Reads battery joltage ratings from "righe.txt" and calculates
/// the maximum joltage possible from each battery bank.
/// 
/// The file should contain one battery bank per line, with each bank
/// represented as a sequence of digits (1-9) indicating joltage ratings.
pub fn main() {
  case simplifile.read("righe.txt") {
    // Handle file read error
    Error(_) -> io.println("Errore: non trovo righe.txt")
    // Process file content successfully read
    Ok(content) -> {
      // Split file content into lines (one per battery bank)
      let lines = string.split(content, "\n")
      // Process each line to find maximum joltage
      let pollo = f(lines)
      echo "_____________________"
      echo pollo
      echo "_____________________"
      let daunireacoppie = f2(pollo)

      echo "---------------------"
      echo daunireacoppie
      echo "---------------------"

      let a = unisci_e_somma(daunireacoppie)
      echo a
      // Confirm successful completion
      io.println("File read successfully")
    }
  }
}
