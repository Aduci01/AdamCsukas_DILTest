protocol SomeApiService {
	func fetchData(completion: @escaping (Result<SomeResponse, Error>) -> Void)
}
