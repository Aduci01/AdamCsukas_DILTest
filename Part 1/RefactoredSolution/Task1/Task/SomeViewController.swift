import UIKit

final class SomeViewController: UIViewController {
	private enum Layout {
		static let cellHeight: CGFloat = 150
	}

	@IBOutlet var detailViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var detailsView: UIView!

	private let viewModel: SomeViewModel
	private let layoutConstants: SomeViewControllerDeviceSpecificLayoutConstants

	init(viewModel: SomeViewModel) {
		self.viewModel = viewModel

		// TODO: introduce a factory which creates the correct device specific constants
		self.layoutConstants = Utility.isIPhone() ? .init(widthMultiplier: 0.9, minSpacing: 24) : .init(widthMultiplier: 0.3, minSpacing: (view.frame.width * 0.3))
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViewModelBindings()
		setupCollectionView()
		viewModel.fetchData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.rightBarButtonItem = UIBarButtonItem.init(
			title: NSLocalizedString("Done", comment: ""),
			style: .plain, target: self,
			action: #selector(dissmissController))
	}

	@objc func dissmissController() {
		// TODO: navigation should be handled in a coordinator
		dismiss(animated: true)
	}

	@IBAction func closeShowDetails() {
		self.detailViewWidthConstraint.constant = 0
		UIView.animate(
			withDuration: 0.5,
			animations: {
				self.view.layoutIfNeeded()
			}
		) { _ in
			self.detailsView.removeFromSuperview()
		}
	}

	@IBAction func showDetails() {
		self.detailViewWidthConstraint.constant = 100
		UIView.animate(
			withDuration: 0.5,
			animations: {
				self.view.layoutIfNeeded()
			})
		{ _ in
			self.view.addSubview(self.detailsView)
		}
	}

	private func setupViewModelBindings() {
		viewModel.onDataSourceUpdated = { [weak self] in
			DispatchQueue.main.async {
				self?.collectionView.reloadData()
			}
		}
	}

	private func setupCollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(
			UINib(nibName: "someCell", bundle: nil), forCellWithReuseIdentifier: "someCell")
	}
}

// MARK: Collection View
extension SomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.dataSource.count
	}

	func collectionView(
		_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cellModel = viewModel.dataSource[indexPath.section][indexPath.row]

		if let someCellModel = cellModel as? SomeCellModel {
			let someCell: SomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "someCell", for: indexPath)
			someCell.setup(with: someCellModel)
			return someCell
		} else {
			print("unhandled cellModel")
			return UICollectionViewCell()
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		showDetails()
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let width = view.frame.width * layoutConstants.widthMultiplier
		return CGSize(width: width, height: Layout.cellHeight)
	}

	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		return layoutConstants.minSpacing
	}
}
