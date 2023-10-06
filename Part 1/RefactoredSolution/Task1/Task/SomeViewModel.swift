protocol SomeViewModel: AnyObject {
	var onDataSourceUpdated: (() -> Void)? { get set }

	var dataSource: [[CellModel]] { get }

	func fetchData()
}
