import UIKit

class PacksViewController: BaseViewController {
    override func viewDidLoad() { super.viewDidLoad(); title = "Packs"; stack.addArrangedSubview(heading("Packs & add-ons", subtitle: "Organize supported files imported to this device.")); stack.addArrangedSubview(card("Compatibility", body: "Blockside can identify file extensions, but it does not inspect every pack manifest or confirm compatibility with a specific Minecraft version. Importing a pack does not enable it in-game.", icon: "ⓘ")); stack.addArrangedSubview(card("Browse packs", body: "No built-in catalog is configured. Use Library to import a pack from a source you trust.", icon: "⌕")); NotificationCenter.default.addObserver(self, selector: #selector(rebuild), name: .libraryDidChange, object: nil); rebuild() }
    @objc private func rebuild() {
        stack.arrangedSubviews.filter { $0.accessibilityIdentifier == "pack-row" }.forEach { stack.removeArrangedSubview($0); $0.removeFromSuperview() }
        let packs = LibraryStore.shared.entries.filter { $0.kind == .pack || $0.kind == .addon }
        if packs.isEmpty { stack.addArrangedSubview(card("No packs imported", body: "Import .mcpack, .mcaddon, or .zip files in Library.")) }
        packs.forEach { entry in
            let row = CardView(title: entry.name, body: "\(entry.kind.rawValue.capitalized) · Stored locally\nNot enabled in Minecraft", icon: "▧"); row.accessibilityIdentifier = "pack-row"
            let button = UIButton(type: .system); button.setTitle(entry.enabled ? "Organized ✓" : "Mark organized", for: .normal); button.tintColor = Palette.green; button.addTarget(self, action: #selector(toggle(_:)), for: .touchUpInside); button.accessibilityIdentifier = entry.id; row.addSubview(button); button.translatesAutoresizingMaskIntoConstraints = false; NSLayoutConstraint.activate([button.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -12), button.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -8), button.heightAnchor.constraint(equalToConstant: 38)]); stack.addArrangedSubview(row)
        }
    }
    @objc private func toggle(_ sender: UIButton) { guard var entry = LibraryStore.shared.entries.first(where: { $0.id == sender.accessibilityIdentifier }) else { return }; entry.enabled.toggle(); LibraryStore.shared.update(entry) }
}
