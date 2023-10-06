import SwiftUI

struct LineRendererView: View {
	let lines: [Line]

	var body: some View {
		ForEach(lines) { line in
			let path = Path { path in
				path.move(
					to: CGPoint(
						x: 0,
						y: 0
					)
				)
				path.addLines(line.points)
			}
			path.strokedPath(.init(lineWidth: line.width))
				.foregroundColor(line.color)
		}
	}
}

struct LineRendererView_Previews: PreviewProvider {
	static var previews: some View {
		LineRendererView(
			lines: [
				.init(
					color: .red,
					width: 2.0,
					points: [
						.init(x: 0, y: 30),
						.init(x: 200, y: 700)
					])
			])
	}
}
