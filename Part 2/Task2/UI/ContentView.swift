import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = DrawViewModel()

	var body: some View {
		ZStack(alignment: .bottom) {
			// Drawing area - based on further requirements, it can be changed
			Rectangle()
				.foregroundColor(.white)
				.gesture(
					DragGesture(minimumDistance: 0, coordinateSpace: .local)
						.onChanged({ value in
							let newPoint = value.location
							viewModel.onDragGesture(newPoint)
						})
						.onEnded({ value in
							viewModel.onDragEnded()
						}))

			LineRendererView(lines: viewModel.linesUnderDrawing)
			LineRendererView(lines: viewModel.completedLines)

			// TODO: Refactor the bottom bar to a common view
			GhostSelectorView(selectedType: $viewModel.selectedGhost)
			ToolSelectorView(selectedType: $viewModel.selectedDrawType)
				.offset(x: -130, y: 10)
			Slider(value: $viewModel.lineWidth, in: 1...20) .frame(maxWidth: 120)
				.rotationEffect(.degrees(-90.0), anchor: .topLeading)
				.offset(x: 170, y: 40)
		}.padding()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
