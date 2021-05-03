//
//  GameViewModel.swift
//  AITicTacToe
//
//  Created by Петрос Тепоян on 5/3/21.
//

import SwiftUI

final class GameViewModel: ObservableObject {
	let columns: [GridItem] = [GridItem(.flexible()),
							   GridItem(.flexible()),
							   GridItem(.flexible())]
	
	private var winPatterns: Set<Set<Int>> = [[0,1,2],
											  [3,4,5],
											  [6,7,8],
											  [0,3,6],
											  [1,4,7],
											  [2,5,8],
											  [0,4,8],
											  [2,4,6]]
	
	@Published var moves: [Move?] = Array(repeating: nil, count: 9)
	@Published var isGameboardDisabled: Bool = false
	@Published var alertItem: AlertItem?
	@Published var winCounter: WinCounter = WinCounter()
	func processPlayerMove(for i: Int) {
		guard moves[i] == nil else { return }
		moves[i] = Move(player: .human, boardIndex: i)
		
		if checkWinCondition(for: .human, in: moves) {
			alertItem = AlertContext.humanWin
			winCounter.human += 1
			return
		}
		
		if checkForDraw(in: moves) {
			alertItem = AlertContext.draw
			winCounter.draw += 1
			return
		}
		
		isGameboardDisabled = true
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  [self] in
			let computerPosition = determineComputerMovePosition(in: moves)
			moves[computerPosition] = Move(player: .computer,
										   boardIndex: computerPosition)
			isGameboardDisabled = false
			
			if checkWinCondition(for: .computer, in: moves) {
				alertItem = AlertContext.computerWin
				winCounter.computer += 1
				return
			}
			
			if checkForDraw(in: moves) {
				alertItem = AlertContext.draw
				winCounter.draw += 1
				return
			}
		}
	}
	
	func playerMovePosition(player: Player) -> Int? {
		let playerMoves: [Move] = moves.compactMap { $0 }.filter { $0.player == player }
		let playerPositions: Set<Int> = Set(playerMoves.map { $0.boardIndex })
		
		for pattern in winPatterns {
			let winPositions = pattern.subtracting(playerPositions)
			if winPositions.count == 1 {
				let isAvailible = moves[winPositions.first!] == nil
				if isAvailible { return winPositions.first! }
			}
		}
		
		return nil
	}
	
	
	func determineComputerMovePosition(in moves: [Move?]) -> Int {
		
		// If AI can win, then win
		
		if let position = playerMovePosition(player: .computer) {
			return position
		}
		
		// If AI can't win, then block
		if let position = playerMovePosition(player: .human) {
			return position
		}
		
		// If AI can't block, then take the middle square
		let centerSquare = 4
		if moves[centerSquare] == nil {
			return centerSquare
		}
		
		// If AI can't take the middle square, take random availible square
		var movePosition = Int.random(in: 0..<9)
		
		while moves[movePosition] != nil {
			movePosition = Int.random(in: 0..<9)
		}
		
		return movePosition
	}
	
	func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
		
		let playerMoves: [Move] = moves.compactMap { $0 }.filter { $0.player == player }
		let playerPositions: Set<Int> = Set(playerMoves.map { $0.boardIndex })
		for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
		
		return false
	}
	
	func checkForDraw(in moves: [Move?]) -> Bool {
		return moves.compactMap { $0 }.count == 9
	}
	
	func resetGame() {
		moves = Array(repeating: nil, count: 9)
	}
	
	struct WinCounter {
		var human: Int = 0
		var draw: Int = 0
		var computer: Int = 0
	}
}


