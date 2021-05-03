//
//  GameView.swift
//  AITicTacToe
//
//  Created by Петрос Тепоян on 5/3/21.
//

import SwiftUI

struct GameView: View {
	
	@StateObject private var viewModel = GameViewModel()
	
	var body: some View {
		GeometryReader { geometry in
			VStack {
				Spacer()
				LazyVGrid(columns: viewModel.columns, spacing: 15) {
					ForEach(0..<9) { i in
						ZStack {
							GameRectangleView(proxy: geometry)
							
							if let move = viewModel.moves[i] {
								PlayerIndicatorView(systemImageName: move.indicator)
							}
						}
						.onTapGesture {
							viewModel.processPlayerMove(for: i)
						}
					}
				}
				Spacer()
			}
			.disabled(viewModel.isGameboardDisabled)
			.padding()
			.alert(item: $viewModel.alertItem, content: { alertItem in
				Alert(title: alertItem.title,
					  message: alertItem.message,
					  dismissButton: .default(alertItem.buttonTitle, action: viewModel.resetGame))
			})
			
		}
	}
	
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		GameView()
	}
}

struct GameRectangleView: View {
	
	var proxy: GeometryProxy
	
	var body: some View {
		Rectangle()
			.foregroundColor(.orange)
			.frame(width: proxy.size.width / 3 - 15,
				   height: proxy.size.width / 3 - 15)
			.cornerRadius(20)
	}
}

struct PlayerIndicatorView: View {
	
	var systemImageName: String
	
	var body: some View {
		Image(systemName: systemImageName)
			.resizable()
			.frame(width: 40, height: 40)
			.foregroundColor(.white)
	}
}

