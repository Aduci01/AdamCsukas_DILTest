enum DrawToolType: CaseIterable {
	case eraser
	case brush

	var iconString: String {
		switch self {
		case .eraser:
			return "eraser.fill"
		case .brush:
			return "paintbrush.pointed.fill"
		}
	}
}
