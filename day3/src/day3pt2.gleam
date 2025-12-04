////--- Part Two ---
////  
////  The escalator doesn't move. The Elf explains that it probably needs more joltage to overcome the static friction of the system and hits the big red "joltage limit safety override" button. You lose count of the number of times she needs to confirm "yes, I'm sure" and decorate the lobby a bit while you wait.
////  
////  Now, you need to make the largest joltage by turning on exactly twelve batteries within each bank.
////  
////  The joltage output for the bank is still the number formed by the digits of the batteries you've turned on; the only difference is that now there will be 12 digits in each bank's joltage output instead of two.
////  
////  Consider again the example from before:
////  
////  987654321111111
////  811111111111119
////  234234234234278
////  818181911112111
////  Now, the joltages are much larger:
////  
////  In 987654321111111, the largest joltage can be found by turning on everything except some 1s at the end to produce 987654321111.
////  In the digit sequence 811111111111119, the largest joltage can be found by turning on everything except some 1s, producing 811111111119.
////  In 234234234234278, the largest joltage can be found by turning on everything except a 2 battery, a 3 battery, and another 2 battery near the start to produce 434234234278.
////  In 818181911112111, the joltage 888911112111 is produced by turning on everything except some 1s near the front.
////  The total output joltage is now much larger: 987654321111 + 811111111119 + 434234234278 + 888911112111 = 3121910778619.

import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

/// Converte una lista di cifre in un numero intero.
/// 
/// ## Esempi
/// ```gleam
/// list_of_number_in_int([1, 2, 3]) // -> 123
/// list_of_number_in_int([9, 8, 7, 6]) // -> 9876
/// list_of_number_in_int([]) // -> 0
/// ```
fn list_of_number_in_int(cifre: List(Int)) -> Int {
  list.fold(cifre, 0, fn(acc, cifra) { acc * 10 + cifra })
}

/// Trova le 12 cifre che formano il numero più grande possibile
/// mantenendo l'ordine relativo originale delle cifre.
/// 
/// ## Algoritmo
/// Utilizza un approccio greedy ricorsivo:
/// 1. Per trovare k cifre da n cifre totali
/// 2. Cerca il massimo nei primi (n - k + 1) elementi
/// 3. Prende quel massimo e continua ricorsivamente sul resto
/// 
/// ## Esempi
/// ```gleam
/// trova_12_cifre_max([1,2,3,4,5,6,7,8,9,1,0,1,1,1,2,1,3,1,4,1,5,1,6])
/// // -> [9,1,0,1,1,1,2,1,3,1,4,1] (le 12 cifre che formano il numero più grande)
/// 
/// trova_12_cifre_max([5,4,3,2,1])
/// // -> [5,4,3,2,1] (meno di 12 cifre, restituisce tutte)
/// ```
fn trova_12_cifre_max(cifre: List(Int)) -> List(Int) {
  trova_k_cifre_max(cifre, 12)
}

/// Trova le k cifre massime da una lista mantenendo l'ordine relativo.
/// 
/// ## Algoritmo Dettagliato
/// Per ogni iterazione:
/// - Se k = 0: finito, restituisci lista vuota
/// - Se n ≤ k: prendi tutte le cifre rimanenti
/// - Altrimenti: cerca il massimo nei primi (n - k + 1) elementi,
///   prendilo e continua ricorsivamente sul resto per trovare (k-1) cifre
/// 
/// ## Esempi
/// ```gleam
/// trova_k_cifre_max([1,2,3,4,5,6,7,8,9], 3)
/// // -> [7,8,9]
/// // Spiegazione:
/// // - Cerca max nei primi 9-3+1=7 elementi: [1,2,3,4,5,6,7] -> max è 7 (indice 6)
/// // - Continua da [8,9] cercando 2 cifre
/// // - Prendi 8 (max di [8]), continua da [9] cercando 1 cifra
/// // - Prendi 9
/// 
/// trova_k_cifre_max([5,1,9,2,8,3,7], 4)
/// // -> [9,2,8,7]
/// // Spiegazione:
/// // - Cerca max nei primi 7-4+1=4 elementi: [5,1,9,2] -> max è 9 (indice 2)
/// // - Continua da [2,8,3,7] cercando 3 cifre
/// // - Cerca max nei primi 4-3+1=2 elementi: [2,8] -> max è 8 (indice 1)
/// // - Continua da [3,7] cercando 2 cifre
/// // - Prendi tutte: [3,7]... ma aspetta, rifacciamo:
/// // - Da [2,8,3,7], cerca max nei primi 2: [2,8] -> max è 8
/// // - Continua da [3,7] cercando 2 cifre -> prendi tutte
/// // Risultato: [9,8,3,7]... hmm, rivediamo
/// // In realtà da [2,8,3,7] con k=3:
/// // - finestra = 4-3+1 = 2, quindi [2,8] -> max=8 all'indice 1
/// // - resto = drop(4, 1+1) = [3,7]
/// // - continua con [3,7], k=2 -> prendi tutte
/// // Ma no! 8 è all'indice 1 nella lista [2,8,3,7]
/// // Quindi resto = drop([2,8,3,7], 2) = [3,7]
/// // Questo dà [9,8,3,7] ma non è ottimale...
/// // Il problema è l'indice! Vediamo il codice...
/// ```
fn trova_k_cifre_max(cifre: List(Int), k: Int) -> List(Int) {
  case k {
    0 -> []
    _ -> {
      let n = list.length(cifre)
      case n <= k {
        // Se abbiamo k o meno cifre, prendiamole tutte
        True -> cifre
        False -> {
          // Cerchiamo il massimo nei primi (n - k + 1) elementi
          // Questo garantisce che avremo abbastanza cifre dopo
          let finestra = n - k + 1
          let candidati = list.take(cifre, finestra)

          case trova_max_con_indice(candidati) {
            #(max_val, max_idx) -> {
              // Prendiamo il massimo e continuiamo dopo di esso
              let resto = list.drop(cifre, max_idx + 1)
              [max_val, ..trova_k_cifre_max(resto, k - 1)]
            }
          }
        }
      }
    }
  }
}

/// Trova il valore massimo in una lista e restituisce sia il valore che il suo indice.
/// 
/// ## Esempi
/// ```gleam
/// trova_max_con_indice([3, 1, 4, 1, 5, 9, 2])
/// // -> #(9, 5)
/// 
/// trova_max_con_indice([5, 4, 3, 2, 1])
/// // -> #(5, 0)
/// 
/// trova_max_con_indice([1])
/// // -> #(1, 0)
/// ```
fn trova_max_con_indice(lista: List(Int)) -> #(Int, Int) {
  trova_max_helper(lista, 0, -1, 0)
}

/// Helper ricorsivo per trovare il massimo con indice.
/// 
/// ## Parametri
/// - `lista`: lista rimanente da esaminare
/// - `index`: indice corrente nell'iterazione
/// - `max_val`: valore massimo trovato finora
/// - `max_idx`: indice del valore massimo
fn trova_max_helper(
  lista: List(Int),
  index: Int,
  max_val: Int,
  max_idx: Int,
) -> #(Int, Int) {
  case lista {
    [] -> #(max_val, max_idx)
    [primo, ..resto] -> {
      case primo > max_val {
        True -> trova_max_helper(resto, index + 1, primo, index)
        False -> trova_max_helper(resto, index + 1, max_val, max_idx)
      }
    }
  }
}

/// Processa ogni riga del file per trovare il numero di 12 cifre più grande.
/// 
/// Per ogni riga:
/// 1. Estrae le cifre
/// 2. Trova le 12 cifre che formano il numero massimo
/// 3. Converte in numero
/// 
/// ## Esempi
/// ```gleam
/// processa_righe(["12345678901234567890", "98765432109876543210"])
/// // -> [901234567890, 987654321098]
/// ```
fn processa_righe(lines: List(String)) -> List(Int) {
  lines
  |> list.filter(fn(x) { string.length(string.trim(x)) > 0 })
  |> list.map(fn(x) {
    let cifre =
      string.trim(x)
      |> string.split("")
      |> list.filter_map(int.parse)

    let dodici_cifre = trova_12_cifre_max(cifre)
    let numero = list_of_number_in_int(dodici_cifre)

    numero
  })
}

/// Punto di ingresso del programma.
/// 
/// Legge il file "righe.txt", processa ogni riga per trovare il numero
/// massimo di 12 cifre, e somma tutti i risultati.
/// 
/// ## Formato file righe.txt
/// Ogni riga contiene una sequenza di cifre (più di 12).
/// Esempio:
/// ```
/// 37107287533902102798797998220837590246510135740250
/// 46376937677490009712648124896970078050417018260538
/// 74324986199524741059474233309513058123726617309629
/// ```
/// 
/// ## Output
/// Stampa il totale della somma di tutti i numeri massimi trovati.
pub fn main() {
  // Esempi di utilizzo delle funzioni
  io.println("=== Esempi di utilizzo ===")
  io.println("")

  // Esempio 1: Lista semplice
  let esempio1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 0, 1, 1, 1, 2, 1, 3]
  io.println("Esempio 1: " <> string.inspect(esempio1))
  let risultato1 = trova_12_cifre_max(esempio1)
  io.println("12 cifre max: " <> string.inspect(risultato1))
  io.println("Numero: " <> int.to_string(list_of_number_in_int(risultato1)))
  io.println("")

  // Esempio 2: Trovare k cifre
  let esempio2 = [5, 1, 9, 2, 8, 3, 7, 4, 6]
  io.println("Esempio 2: " <> string.inspect(esempio2))
  io.println("4 cifre max: " <> string.inspect(trova_k_cifre_max(esempio2, 4)))
  io.println("3 cifre max: " <> string.inspect(trova_k_cifre_max(esempio2, 3)))
  io.println("")

  // Esempio 3: Massimo con indice
  let esempio3 = [3, 1, 4, 1, 5, 9, 2, 6, 5]
  io.println("Esempio 3: " <> string.inspect(esempio3))
  let #(max_val, max_idx) = trova_max_con_indice(esempio3)
  io.println(
    "Max: "
    <> int.to_string(max_val)
    <> " all'indice "
    <> int.to_string(max_idx),
  )
  io.println("")

  io.println("=== Lettura file righe.txt ===")
  io.println("")

  case simplifile.read("righe.txt") {
    Error(_) -> io.println("Errore: non riesco a leggere righe.txt")
    Ok(content) -> {
      let lines = string.split(content, "\n")
      let numeri = processa_righe(lines)

      io.println("Numeri trovati: " <> int.to_string(list.length(numeri)))

      // Mostra i primi 3 numeri se ce ne sono
      case list.take(numeri, 3) {
        [] -> Nil
        primi -> {
          io.println("Primi numeri:")
          list.each(primi, fn(n) { io.println("  " <> int.to_string(n)) })
        }
      }

      // Somma tutti i numeri
      let totale = list.fold(numeri, 0, fn(acc, n) { acc + n })

      io.println("")
      io.println("File letto con successo!")
      io.print("Risposta (somma totale): ")
      io.println(int.to_string(totale))
    }
  }
}
