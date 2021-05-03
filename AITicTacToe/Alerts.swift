//
//  Alerts.swift
//  AITicTacToe
//
//  Created by Петрос Тепоян on 5/3/21.
//

import SwiftUI

struct AlertItem: Identifiable {
	var id = UUID()
	var title: Text
	var message: Text
	var buttonTitle: Text
}

struct AlertContext {
	static let humanWin = AlertItem(title: Text("You win!"),
									message: Text("You are so smart, you beat your own AI"),
									buttonTitle: Text("Hell yeah"))
	
	static let computerWin = AlertItem(title: Text("You lost!"),
									message: Text("You programmed a super AI"),
									buttonTitle: Text("Rematch"))
	
	static let draw = AlertItem(title: Text("Draw!"),
									message: Text("What a battle of wits we have here..."),
									buttonTitle: Text("Try again"))
	
}
