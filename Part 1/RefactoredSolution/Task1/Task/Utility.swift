import UIKit

enum Utility {
	static func isIPhone() -> Bool {
		return UIDevice.current.userInterfaceIdiom == .phone
	}
}
