import Foundation

final class SomeViewModelImpl: SomeViewModel {
	var onDataSourceUpdated: (() -> Void)?

	private(set) var dataSource: [[CellModel]] = [] {
		didSet {
			onDataSourceUpdated?()
		}
	}

	private let apiService: SomeApiService

	// Should be transformed to domain model, instead of using the response
	private var fetchedDataModel: SomeResponse?

	init(apiService: SomeApiService) {
		self.apiService = apiService
	}

	func fetchData() {
		apiService.fetchData { [weak self] result in
			guard let strongSelf = self else { return }

			switch result {
			case .success(let data):
				strongSelf.fetchedDataModel = data
				strongSelf.buildDataSource()
			case .failure(let error):
				// handle error
				print(error.localizedDescription)
				break
			}
		}
	}

	private func buildDataSource() {
		// Setting up cellModels in the dataSource using the fetchedDataModel
	}
}
