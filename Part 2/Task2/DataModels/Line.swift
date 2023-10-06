import SwiftUI

struct Line: Identifiable, Equatable {
	let id = UUID()
	let color: Color
	let width: CGFloat

	var points: [CGPoint] = []
}
