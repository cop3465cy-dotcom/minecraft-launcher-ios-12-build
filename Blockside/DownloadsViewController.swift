import UIKit

struct DownloadRecord: Codable { var id: String; var url: String; var filename: String; var state: String; var date: Date; var progress: Double? }
class DownloadsViewController: BaseViewController, URLSessionDownloadDelegate {
    private let key = "blockside.downloads.v1"
    private var records: [DownloadRecord] { get { guard let data = UserDefaults.standard.data(forKey: key) else { return [] }; return (try? JSONDecoder().decode([DownloadRecord].self, from: data)) ?? [] } set { if let d = try? JSONEncoder().encode(newValue) { UserDefaults.standard.set(d, forKey: key) } } }
    private var tasks: [Int: String] = [:]
    override func viewDidLoad() { super.viewDidLoad(); title = "Downloads"; stack.addArrangedSubview(heading("Downloads", subtitle: "Download files from URLs you provide. Blockside does not distribute Minecraft.")); let b = ActionButton("Download from URL"); b.addTarget(self, action: #selector(addDownload), for: .touchUpInside); stack.addArrangedSubview(b); stack.addArrangedSubview(card("File verification", body: "Transfers use HTTPS when the supplied server supports it. This manager does not validate game signatures or file compatibility. Check important files with their publisher.", icon: "✓")); rebuild() }
    @objc private func addDownload() {
        let a = UIAlertController(title: "Download a file", message: "Enter a direct HTTPS or HTTP file URL.", preferredStyle: .alert); a.addTextField { $0.placeholder = "https://example.com/file.mcpack"; $0.keyboardType = .URL; $0.autocapitalizationType = .none }
        a.addAction(UIAlertAction(title: "Cancel", style: .cancel)); a.addAction(UIAlertAction(title: "Download", style: .default) { [weak self] _ in guard let self = self, let text = a.textFields?.first?.text, let url = URL(string: text), let scheme = url.scheme?.lowercased(), ["https", "http"].contains(scheme), url.host != nil else { self?.showMessage("Invalid URL", "Enter a complete http or https URL."); return }; self.start(url) }); present(a, animated: true)
    }
    private func start(_ url: URL) {
        let config = URLSessionConfiguration.default; config.timeoutIntervalForResource = 60 * 60
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main); let task = session.downloadTask(with: url); tasks[task.taskIdentifier] = url.absoluteString
        var list = records; list.insert(DownloadRecord(id: String(task.taskIdentifier), url: url.absoluteString, filename: url.lastPathComponent.isEmpty ? "download" : url.lastPathComponent, state: "Downloading", date: Date(), progress: 0), at: 0); records = list; rebuild(); task.resume()
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let id = tasks[downloadTask.taskIdentifier], totalBytesExpectedToWrite > 0 else { return }
        var list = records
        if let i = list.firstIndex(where: { $0.id == id }) {
            let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            let state = "Downloading · \(Int(progress * 100))%"
            guard list[i].state != state else { return }
            list[i].progress = progress; list[i].state = state; records = list
            rebuild()
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let id = tasks[downloadTask.taskIdentifier], let url = URL(string: id) else { return }
        let name = url.lastPathComponent.isEmpty ? "download-\(downloadTask.taskIdentifier)" : url.lastPathComponent
        do { let destination = LibraryStore.shared.folder.appendingPathComponent(name); var final = destination; if FileManager.default.fileExists(atPath: final.path) { final = LibraryStore.shared.folder.appendingPathComponent("download-\(Date().timeIntervalSince1970)-\(name)") }; try FileManager.default.moveItem(at: location, to: final); setState(id, "Completed · \(final.lastPathComponent)") } catch { setState(id, "Failed: \(error.localizedDescription)") }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) { if let error = error, let id = tasks[task.taskIdentifier] { setState(id, "Failed: \(error.localizedDescription)") } }
    private func setState(_ id: String, _ state: String) { var list = records; if let i = list.firstIndex(where: { $0.id == id }) { list[i].state = state; records = list }; rebuild() }
    private func rebuild() { stack.arrangedSubviews.filter { $0.accessibilityIdentifier == "download-row" }.forEach { stack.removeArrangedSubview($0); $0.removeFromSuperview() }; if records.isEmpty { stack.addArrangedSubview(card("No downloads yet", body: "Your completed and failed downloads will appear here.")) }; records.forEach { r in let row = CardView(title: r.filename, body: "\(r.state)\n\(DateFormatter.localizedString(from: r.date, dateStyle: .short, timeStyle: .short))", icon: "↓"); row.accessibilityIdentifier = "download-row"; if let p = r.progress, r.state.hasPrefix("Downloading") { let bar = UIProgressView(progressViewStyle: .default); bar.progressTintColor = Palette.green; bar.progress = Float(p); row.addSubview(bar); bar.translatesAutoresizingMaskIntoConstraints = false; NSLayoutConstraint.activate([bar.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16), bar.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16), bar.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -8)]) }; if r.state.hasPrefix("Failed") { let retry = UIButton(type: .system); retry.setTitle("Retry", for: .normal); retry.accessibilityIdentifier = r.url; retry.addTarget(self, action: #selector(retryDownload(_:)), for: .touchUpInside); row.addSubview(retry); retry.translatesAutoresizingMaskIntoConstraints = false; NSLayoutConstraint.activate([retry.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -12), retry.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -8)]); }; stack.addArrangedSubview(row) } }
    @objc private func retryDownload(_ sender: UIButton) { guard let value = sender.accessibilityIdentifier, let url = URL(string: value) else { return }; start(url) }
}
