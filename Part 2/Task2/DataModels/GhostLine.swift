import SwiftUI

struct GhostLine {
	var pointsToDraw: [TimeStampPoint] = []
}

struct TimeStampPoint: Equatable {
	let point: CGPoint
	let timeStamp = Date()
}
