import Foundation

final class DrawViewModel: ObservableObject {
	@Published var lineWidth: CGFloat = 2.0
	@Published var selectedGhost: GhostType = .red
	@Published var selectedDrawType: DrawToolType = .brush
	@Published private(set) var linesUnderDrawing: [Line] = []
	@Published private(set) var completedLines: [Line] = []

	private let eraserDelay = 2.0

	private var currentPoints: [TimeStampPoint] = []

	func onDragGesture(_ point: CGPoint) {
		currentPoints.append(TimeStampPoint(point: point))
	}

	func onDragEnded() {
		let pointsToPass = currentPoints
		let ghostType: GhostType

		switch selectedDrawType {
		case .eraser:
			ghostType = .eraser
		case .brush:
			ghostType = selectedGhost
		}

		linesUnderDrawing.append(
			Line(color: ghostType.color, width: lineWidth, points: []))
		Task { [weak self] in
			await self?.drawGhostLine(points: pointsToPass, idx: linesUnderDrawing.count - 1, delay: selectedGhost.drawDelay)
		}

		currentPoints = []
	}

	func ghostLineCompleted(idx: Int) {
		completedLines.append(linesUnderDrawing[idx])
		linesUnderDrawing[idx].points = []
	}

	@MainActor
	private func drawGhostLine(points: [TimeStampPoint], idx: Int, delay: Double) async {
		try? await Task.sleep(for: .seconds(delay))

		for (pointIdx, timeStampPoint) in points.enumerated() {
			linesUnderDrawing[idx].points.append(timeStampPoint.point)
			guard pointIdx != points.count - 1 else {
				ghostLineCompleted(idx: idx)
				return
			}

			let delay: Duration = .seconds(points[pointIdx + 1].timeStamp.timeIntervalSince(timeStampPoint.timeStamp))
			try? await Task.sleep(for: delay)
		}
	}

	// TODO: Eraser implementation, where the points will be deleted
	/*@MainActor
	private func eraseLine(points: [TimeStampPoint]) async {
		try? await Task.sleep(for: .seconds(eraserDelay))

		for (pointIdx, timeStampPoint) in points.enumerated() {
			completedLines.enumerated().forEach { idx, line in
				var newPoints: [CGPoint?] = line.points
				line.points.enumerated().forEach { newPointIdx, point in
					let distance = abs(point.x - timeStampPoint.point.x) + abs(point.y - timeStampPoint.point.y)
					if distance < 20 {
						newPoints[newPointIdx] = nil
					}
				}

				var startIdx = 0
				for idx in line.points.indices {
					guard newPoints[idx] != nil || startIdx != idx else {
						startIdx += 1
						continue
					}

					if newPoints[idx] == nil {
						let slice = newPoints[startIdx..<idx]
						let compactArray = Array(slice.compactMap { $0 })

						let newLine = Line(color: line.color, points: compactArray)
						completedLines.append(newLine)

						startIdx = idx + 1
					}
				}
				let slice = newPoints[startIdx..<newPoints.count]
				let compactArray = Array(slice.compactMap { $0 })
				let newLine = Line(color: line.color, points: compactArray)
				completedLines.append(newLine)

				completedLines.remove(at: idx)
			}

			guard pointIdx != points.count - 1 else {
				return
			}

			let delay: Duration = .seconds(points[pointIdx + 1].timeStamp.timeIntervalSince(timeStampPoint.timeStamp))
			try? await Task.sleep(for: delay)
		}
	}*/
}
