import UIKit
import Foundation
import Lottie

private struct Strings {
    static let title = NSLocalizedString(
        "Search TV Shows",
        comment: "Text for navigation title")
}

class SearchViewController: UIViewController {
    private let searchView = SearchView()
    let animationView = AnimationView(name: "10201-background-full-screen-night")

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
    }

    private func setupView() {
        view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.play()
        animationView.contentMode = .scaleToFill

        view.addSubview(searchView)

        view.backgroundColor = Colors.white.value
        searchView.delegate = self
        navigationController?.navigationBar.barTintColor = Colors.white.value
        navigationController?.navigationBar.tintColor = Colors.navBarTintColor.value
        navigationItem.title = Strings.title
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back", style: .plain, target: nil, action: nil)
    }

    private func setupConstraints() {
        animationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }

        searchView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startAnimation),
            name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.stop()
    }

    @objc private func startAnimation() {
        animationView.play()
    }
}

extension SearchViewController: SearchViewDelegate {
    func searchButtonTapped() {
        let displayVC = DisplayViewController()
        displayVC.activateSearch = true
        navigationController?.pushViewController(displayVC, animated: true)
        view.endEditing(true)
    }
}
