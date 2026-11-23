import UIKit

enum Palette {
    static var background: UIColor { Preferences.dark ? UIColor(red: 0.08, green: 0.10, blue: 0.11, alpha: 1) : UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1) }
    static var card: UIColor { Preferences.dark ? UIColor(red: 0.14, green: 0.17, blue: 0.18, alpha: 1) : .white }
    static var text: UIColor { Preferences.dark ? .white : UIColor(red: 0.12, green: 0.15, blue: 0.16, alpha: 1) }
    static var secondary: UIColor { Preferences.dark ? UIColor(white: 0.72, alpha: 1) : UIColor(white: 0.42, alpha: 1) }
    static let green = UIColor(red: 0.24, green: 0.55, blue: 0.31, alpha: 1)
}

class BaseViewController: UIViewController {
    let scroll = UIScrollView()
    let stack = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad(); view.backgroundColor = Palette.background
        scroll.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(scroll)
        stack.axis = .vertical; stack.spacing = 16; stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)
        let preferredWidth = stack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40); preferredWidth.priority = .defaultHigh
        NSLayoutConstraint.activate([scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor), scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor), stack.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 18), stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -28), stack.centerXAnchor.constraint(equalTo: scroll.centerXAnchor), stack.widthAnchor.constraint(lessThanOrEqualToConstant: 680), preferredWidth])
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTheme), name: .themeDidChange, object: nil)
    }
    @objc func refreshTheme() { view.backgroundColor = Palette.background; refreshColors(in: stack) }
    private func refreshColors(in item: UIView) { if let card = item as? CardView { card.refreshColors() }; if let label = item as? UILabel { label.textColor = label.font.pointSize > 20 ? Palette.text : Palette.secondary }; item.subviews.forEach { refreshColors(in: $0) } }
    func heading(_ title: String, subtitle: String? = nil) -> UIView {
        let box = UIStackView(); box.axis = .vertical; box.spacing = 4
        let titleLabel = UILabel(); titleLabel.text = title; titleLabel.font = .systemFont(ofSize: 30, weight: .bold); titleLabel.textColor = Palette.text; box.addArrangedSubview(titleLabel)
        if let subtitle = subtitle { let label = UILabel(); label.text = subtitle; label.font = .systemFont(ofSize: 15); label.textColor = Palette.secondary; label.numberOfLines = 0; box.addArrangedSubview(label) }
        return box
    }
    func card(_ title: String, body: String, icon: String? = nil) -> CardView { CardView(title: title, body: body, icon: icon) }
    func showMessage(_ title: String, _ message: String) { let a = UIAlertController(title: title, message: message, preferredStyle: .alert); a.addAction(UIAlertAction(title: "OK", style: .default)); present(a, animated: true) }
}

class CardView: UIView {
    let titleLabel = UILabel(); let bodyLabel = UILabel()
    init(title: String, body: String, icon: String? = nil) {
        super.init(frame: .zero); backgroundColor = Palette.card; layer.cornerRadius = 16; layer.masksToBounds = true
        let v = UIStackView(); v.axis = .vertical; v.spacing = 8; v.translatesAutoresizingMaskIntoConstraints = false; addSubview(v)
        titleLabel.text = (icon.map { $0 + "  " } ?? "") + title; titleLabel.font = .systemFont(ofSize: 17, weight: .semibold); titleLabel.textColor = Palette.text
        bodyLabel.text = body; bodyLabel.font = .systemFont(ofSize: 14); bodyLabel.textColor = Palette.secondary; bodyLabel.numberOfLines = 0
        v.addArrangedSubview(titleLabel); v.addArrangedSubview(bodyLabel)
        NSLayoutConstraint.activate([v.topAnchor.constraint(equalTo: topAnchor, constant: 16), v.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16), v.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), v.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func refreshColors() { backgroundColor = Palette.card; titleLabel.textColor = Palette.text; bodyLabel.textColor = Palette.secondary }
}

class ActionButton: UIButton {
    init(_ title: String, color: UIColor = Palette.green) { super.init(frame: .zero); setTitle(title, for: .normal); titleLabel?.font = .systemFont(ofSize: 17, weight: .bold); backgroundColor = color; layer.cornerRadius = 14; heightAnchor.constraint(equalToConstant: 54).isActive = true; accessibilityTraits = .button }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

func prettySize(_ bytes: Int64) -> String { let f = ByteCountFormatter(); f.countStyle = .file; return f.string(fromByteCount: bytes) }
