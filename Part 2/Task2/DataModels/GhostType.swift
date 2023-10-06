import SwiftUI

/*
 An alternative solution for the "eraser" is drawing a white line on top of the other lines
 case eraser
*/

enum GhostType: CaseIterable {
	case red
	case blue
	case green
	case eraser

	var color: Color {
		switch self {
		case .red:
			return .red
		case .blue:
			return .blue
		case .green:
			return .green
		case .eraser:
			return .white
		}
	}

	var drawDelay: Double {
		switch self {
		case .red:
			return 1.0
		case .blue:
			return 3.0
		case .green:
			return 5.0
		case .eraser:
			return 2.0
		}
	}
}
