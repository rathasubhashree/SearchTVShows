import UIKit

class DisplayDetailedTVShowViewController: UIViewController {

    private let detailView = DisplayDetailedTVShowView()

    var showDetails: DisplayTVShow

    init(showDetails: DisplayTVShow) {
        self.showDetails = showDetails
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        navigationController?.navigationBar.barTintColor = Colors.white.value
        navigationController?.navigationBar.tintColor = Colors.navBarTintColor.value
        navigationController?.isNavigationBarHidden = false
        detailView.update(showDetails: showDetails)
    }
}
