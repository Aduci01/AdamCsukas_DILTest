import SwiftUI

struct GhostSelectorView: View {
	let types: [GhostType] = [.red, .blue, .green]
	@Binding var selectedType: GhostType

	var body: some View {
		HStack {
			ForEach(types, id: \.self) { type in
				Image(systemName: selectedType == type ? "record.circle.fill" : "circle.fill")
					.foregroundColor(type.color)
					.font(.system(size: 30))
					.onTapGesture {
						selectedType = type
					}
			}
		}
	}
}

struct GhostSelectorView_Previews: PreviewProvider {
	static var previews: some View {
		GhostSelectorView(selectedType: .constant(.red))
	}
}
