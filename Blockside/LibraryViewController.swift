import UIKit

class LibraryViewController: BaseViewController, UIDocumentPickerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad(); title = "Library"
        stack.addArrangedSubview(heading("Your library", subtitle: "Imported files are stored locally. Import does not install them into Minecraft."))
        let importButton = ActionButton("Import a file"); importButton.addTarget(self, action: #selector(importTapped), for: .touchUpInside); stack.addArrangedSubview(importButton)
        stack.addArrangedSubview(card("Supported file types", body: "Worlds: .mcworld · Resource packs: .mcpack · Add-ons: .mcaddon · Archives: .zip · Screenshots: common image formats", icon: "📁"))
        NotificationCenter.default.addObserver(self, selector: #selector(reloadItems), name: .libraryDidChange, object: nil); reloadItems()
    }
    @objc private func importTapped() {
        let types = ["com.apple.package", "public.archive", "public.zip-archive", "public.image", "public.data"]
        let picker = UIDocumentPickerViewController(documentTypes: types, in: .import); picker.delegate = self; picker.allowsMultipleSelection = true; present(picker, animated: true)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var errors: [String] = []
        urls.forEach { url in let ext = url.pathExtension.lowercased(); let kind: EntryKind = ext == "mcworld" ? .world : ((ext == "mcpack" || ext == "zip") ? .pack : (ext == "mcaddon" ? .addon : ( ["png", "jpg", "jpeg", "heic"].contains(ext) ? .screenshot : .file)))
            do { try LibraryStore.shared.add(url: url, kind: kind) } catch { errors.append("\(url.lastPathComponent): \(error.localizedDescription)") }
        }
        if !errors.isEmpty { showMessage("Some files could not be imported", errors.joined(separator: "\n")) }
        reloadItems()
    }
    @objc private func reloadItems() {
        stack.arrangedSubviews.filter { $0.accessibilityIdentifier == "library-row" }.forEach { stack.removeArrangedSubview($0); $0.removeFromSuperview() }
        let entries = LibraryStore.shared.entries
        if entries.isEmpty { stack.addArrangedSubview(card("Nothing here yet", body: "Tap Import a file to add a world, pack, add-on, or screenshot.")) }
        entries.forEach { entry in
            let row = CardView(title: entry.name, body: "\(entry.kind.rawValue.capitalized) · \(entry.filename)\nAdded \(DateFormatter.localizedString(from: entry.importedAt, dateStyle: .medium, timeStyle: .short))", icon: icon(entry.kind)); row.accessibilityIdentifier = "library-row"
            let remove = UIButton(type: .system); remove.setTitle("Remove", for: .normal); remove.tintColor = .systemRed; remove.contentHorizontalAlignment = .right; remove.addTarget(self, action: #selector(removeEntry(_:)), for: .touchUpInside); remove.accessibilityIdentifier = entry.id; row.addSubview(remove); remove.translatesAutoresizingMaskIntoConstraints = false; NSLayoutConstraint.activate([remove.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -12), remove.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -8), remove.heightAnchor.constraint(equalToConstant: 38), remove.widthAnchor.constraint(equalToConstant: 82)]); stack.addArrangedSubview(row)
        }
    }
    @objc private func removeEntry(_ sender: UIButton) { guard let entry = LibraryStore.shared.entries.first(where: { $0.id == sender.accessibilityIdentifier }) else { return }; let alert = UIAlertController(title: "Remove \(entry.name)?", message: "This deletes the imported copy from Blockside.", preferredStyle: .alert); alert.addAction(UIAlertAction(title: "Cancel", style: .cancel)); alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in LibraryStore.shared.remove(entry) }); present(alert, animated: true) }
    private func icon(_ kind: EntryKind) -> String { switch kind { case .world: return "🌍"; case .pack: return "▧"; case .addon: return "◇"; case .screenshot: return "▣"; case .file: return "📄" } }
}
