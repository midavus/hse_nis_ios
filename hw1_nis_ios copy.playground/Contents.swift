// объявляю размеры и массивы поля и игроков
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1) // 0..25
let playersCount = 6 // можно поставить от 2 до 6 человек
var players = [Int](repeating: 0, count: playersCount)   // все начинают с 0

//случайное число 1-6
//счётчик 1→6→1
var diceCounter = 0

//рандомная генерация поля перед игрой
//на поле будут 3 лестницы (+) и 3 змеи (-)
var i = 0
while i < board.count {
    board[i] = 0
    i += 1
}

// 3 лестницы
var laddersPlaced = 0
while laddersPlaced < 3 {
    diceCounter += 1; if diceCounter == 7 { diceCounter = 1 } //всего возможно 1-6
    var ladderStart = diceCounter + 3 //рандомная нижняя клетка (в диапазоне 4-9)
    diceCounter += 1; if diceCounter == 7 { diceCounter = 1 }
    var moveUpLadder = 1 + diceCounter  // высота 2-7, !!не забудь убрать высоту лестницы:
    if ladderStart >= finalSquare - 2 { ladderStart = finalSquare - 3 }
    if ladderStart + moveUpLadder >= finalSquare { moveUpLadder = (finalSquare - 1) - ladderStart }
    if moveUpLadder > 0 && board[ladderStart] == 0 && ladderStart > 0 {
        board[ladderStart] = moveUpLadder // когда положительное = лестница вверх
        laddersPlaced += 1
    }
}

// 3 змеи
var snakesPlaced = 0
while snakesPlaced < 3 {
    diceCounter += 1; if diceCounter == 7 { diceCounter = 1 }
    var head = finalSquare - (diceCounter + 1) //рандомная голова во второй половине
    diceCounter += 1; if diceCounter == 7 { diceCounter = 1 }
    var down = 1 + diceCounter // длина 2-7
    if head <= 3 { head = 4 }
    if down >= head { down = head - 1 }
    if down > 0 && board[head] == 0 && head < finalSquare {
        board[head] = -down                // отрицательное = змея вниз
        snakesPlaced += 1
    }
}
//  вывод
print("ход по клеткам (+:лестница,-:змея):")
var c = 1
while c < finalSquare {
    if board[c] != 0 {
        if board[c] > 0 {
            print("  клетка \(c): лестница +\(board[c])")
        } else {
            print("  клетка \(c): змея \(board[c])")
        }
    }
    c += 1
}
print("\n нчать игру")

var currentPlayer = 0
var winner = -1

while winner == -1 { // игра продолжается, пока кто-то не выиграл
    // бросок кубика 1-6
    diceCounter += 1; if diceCounter == 7 { diceCounter = 1 }
    let roll = diceCounter

    let from = players[currentPlayer]
    print("игрок \(currentPlayer + 1) идет с \(roll) до \(from)")

    switch from + roll {
    case finalSquare:
        players[currentPlayer] = finalSquare
        print("игрок \(currentPlayer + 1) достиг \(finalSquare) конец....")
        winner = currentPlayer

    case let newSquare where newSquare > finalSquare:
        print("  слишком много. отсавайся на \(from).")

    default:
        var currentPlayerPosition = from + roll  // обычный ход
        if currentPlayerPosition < board.count { //проверка границ массива
            let shift = board[currentPlayerPosition]
            if shift != 0 {
                if shift > 0 {
                    print("  лестница на \(currentPlayerPosition): сдвиг на +\(shift)")
                } else {
                    print("  змея на \(currentPlayerPosition): сдвиг на \(shift)")
                }
                currentPlayerPosition += shift            // применяем змею/лестницу
            }
        }
        players[currentPlayer] = currentPlayerPosition
        print("  сейчас на \(currentPlayerPosition)")
    }

    // следующий игрок по кругу
    currentPlayer += 1
    if currentPlayer == playersCount { currentPlayer = 0 }
}
