import SwiftUI

struct ToolSelectorView: View {
	@Binding var selectedType: DrawToolType

	private let types = DrawToolType.allCases

	var body: some View {
		VStack {
			ForEach(types, id: \.self) { type in
				Image(systemName: type.iconString)
					.foregroundColor(type == selectedType ? .green : .gray.opacity(0.5))
					.font(.system(size: 30))
					.onTapGesture {
						selectedType = type
					}.padding(.bottom, 4)
			}
		}
		.padding()
		.background(.gray.opacity(0.15))
		.cornerRadius(50)
	}
}

struct ToolSelectorView_Previews: PreviewProvider {
	static var previews: some View {
		ToolSelectorView(selectedType: .constant(.brush))
	}
}
