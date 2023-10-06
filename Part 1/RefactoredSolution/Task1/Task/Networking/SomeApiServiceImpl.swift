import Foundation

final class SomeApiServiceImpl: SomeApiService {
	func fetchData(completion: @escaping (Result<SomeResponse, Error>) -> Void) {
		guard let url = URL(string: "testreq") else { return }

		URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
			if let error {
				completion(.failure(error))
				return
			}
			guard
				let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode),
				let data
			else {
				//completion(.failure(.unexpectedError))
				return
			}

			do {
				let someResponse = try JSONDecoder().decode(SomeResponse.self, from: data)
				completion(.success(someResponse))
			} catch {
				//completion(.failure(.decodingError))
			}
		}.resume()
	}
}
