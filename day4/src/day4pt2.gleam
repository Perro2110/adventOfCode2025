////--- Day 4: Printing Department ---
//// 
//// You ride the escalator down to the printing department. They're clearly getting ready for Christmas; they have lots of large rolls of paper everywhere, and there's even a massive printer in the corner (to handle the really big print jobs).
//// 
//// Decorating here will be easy: they can make their own decorations. What you really need is a way to get further into the North Pole base while the elevators are offline.
//// 
//// "Actually, maybe we can help with that," one of the Elves replies when you ask for help. "We're pretty sure there's a cafeteria on the other side of the back wall. If we could break through the wall, you'd be able to keep moving. It's too bad all of our forklifts are so busy moving those big rolls of paper around."
//// 
//// If you can optimize the work the forklifts are doing, maybe they would have time to spare to break through the wall.
//// 
//// The rolls of paper (@) are arranged on a large grid; the Elves even have a helpful diagram (your puzzle input) indicating where everything is located.
//// 
//// For example:
//// 
//// ..@@.@@@@.
//// @@@.@.@.@@
//// @@@@@.@.@@
//// @.@@@@..@.
//// @@.@@@@.@@
//// .@@@@@@@.@
//// .@.@.@.@@@
//// @.@@@.@@@@
//// .@@@@@@@@.
//// @.@.@@@.@.
//// The forklifts can only access a roll of paper if there are fewer than four rolls of paper in the eight adjacent positions. If you can figure out which rolls of paper the forklifts can access, they'll spend less time looking and more time breaking down the wall to the cafeteria.
//// 
//// In this example, there are 13 rolls of paper that can be accessed by a forklift (marked with x):
//// 
//// ..xx.xx@x.
//// x@@.@.@.@@
//// @@@@@.x.@@
//// @.@@@@..@.
//// x@.@@@@.@x
//// .@@@@@@@.@
//// .@.@.@.@@@
//// x.@@@.@@@@
//// .@@@@@@@@.
//// x.x.@@@.x.

import gleam/int
import gleam/io
import gleam/list
import gleam/string

fn conta_accessibili(griglia) {
  griglia
  |> list.filter(fn(triple) {
    let #(lettera, x, y) = triple
    case lettera {
      "@" -> contavicini(triple, griglia) < 4
      _ -> False
    }
  })
  |> list.length
}

fn contavicini(triple, griglia) {
  let #(_, x, y) = triple

  let posizioni = [
    #(x - 1, y - 1),
    #(x, y - 1),
    #(x + 1, y - 1),
    #(x - 1, y),
    #(x + 1, y),
    #(x - 1, y + 1),
    #(x, y + 1),
    #(x + 1, y + 1),
  ]

  posizioni
  |> list.filter(fn(pos) {
    let #(px, py) = pos
    griglia
    |> list.any(fn(t) {
      let #(lettera, gx, gy) = t
      gx == px && gy == py && lettera == "@"
    })
  })
  |> list.length
}

fn rimuovi_accessibili(griglia) {
  let accessibili =
    griglia
    |> list.filter(fn(triple) {
      let #(lettera, x, y) = triple
      case lettera {
        "@" -> contavicini(triple, griglia) < 4
        _ -> False
      }
    })

  let nuova_griglia =
    griglia
    |> list.map(fn(triple) {
      let #(lettera, x, y) = triple
      let da_rimuovere =
        accessibili
        |> list.any(fn(acc) {
          let #(_, ax, ay) = acc
          x == ax && y == ay
        })

      case da_rimuovere {
        True -> #(".", x, y)
        False -> triple
      }
    })

  #(list.length(accessibili), nuova_griglia)
}

fn rimuovi_iterativamente(griglia, totale_rimossi) {
  let #(rimossi, nuova_griglia) = rimuovi_accessibili(griglia)
  case rimossi {
    0 -> totale_rimossi
    _ -> {
      io.println("Rimossi " <> int.to_string(rimossi) <> " rotoli")
      rimuovi_iterativamente(nuova_griglia, totale_rimossi + rimossi)
    }
  }
}

pub fn main() {
  let s =
    "..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."

  let pollo = string.split(s, "\n")
  let triples =
    list.index_map(pollo, fn(row, y_pos) {
      let chars = string.split(row, "")
      list.index_map(chars, fn(lettera, x_pos) { #(lettera, x_pos, y_pos) })
    })
    |> list.flatten

  let griglia = triples

  let totale = rimuovi_iterativamente(griglia, 0)
  io.println("Totale rotoli rimossi: " <> int.to_string(totale))
}
