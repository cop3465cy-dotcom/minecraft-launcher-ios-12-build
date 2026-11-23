import Foundation
import UIKit

extension Notification.Name { static let libraryDidChange = Notification.Name("BlocksideLibraryDidChange") }

enum EntryKind: String, Codable { case world, pack, addon, screenshot, file }
struct LibraryEntry: Codable {
    var id: String
    var name: String
    var filename: String
    var kind: EntryKind
    var importedAt: Date
    var enabled: Bool
}

final class LibraryStore {
    static let shared = LibraryStore()
    private let defaultsKey = "blockside.library.v1"
    private let defaults = UserDefaults.standard
    private init() { try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil) }
    var folder: URL { return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Blockside Library", isDirectory: true) }
    var entries: [LibraryEntry] {
        guard let data = defaults.data(forKey: defaultsKey), let result = try? JSONDecoder().decode([LibraryEntry].self, from: data) else { return [] }
        return result.sorted { $0.importedAt > $1.importedAt }
    }
    func add(url: URL, kind: EntryKind) throws {
        let access = url.startAccessingSecurityScopedResource()
        defer { if access { url.stopAccessingSecurityScopedResource() } }
        let safeName = url.lastPathComponent.isEmpty ? "Imported file" : url.lastPathComponent
        var destination = folder.appendingPathComponent(safeName)
        if FileManager.default.fileExists(atPath: destination.path) {
            let ext = destination.pathExtension
            destination = folder.appendingPathComponent("\(destination.deletingPathExtension().lastPathComponent)-\(Int(Date().timeIntervalSince1970)).\(ext)")
        }
        try FileManager.default.copyItem(at: url, to: destination)
        var all = entries
        all.insert(LibraryEntry(id: UUID().uuidString, name: destination.deletingPathExtension().lastPathComponent, filename: destination.lastPathComponent, kind: kind, importedAt: Date(), enabled: false), at: 0)
        save(all)
    }
    func update(_ entry: LibraryEntry) { var all = entries; if let i = all.firstIndex(where: { $0.id == entry.id }) { all[i] = entry; save(all) } }
    func remove(_ entry: LibraryEntry) { try? FileManager.default.removeItem(at: folder.appendingPathComponent(entry.filename)); save(entries.filter { $0.id != entry.id }) }
    func sizeBytes() -> Int64 {
        let urls = (try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.fileSizeKey], options: [.skipsHiddenFiles])) ?? []
        return urls.reduce(Int64(0)) { total, url in total + Int64((try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0) }
    }
    private func save(_ entries: [LibraryEntry]) { if let data = try? JSONEncoder().encode(entries) { defaults.set(data, forKey: defaultsKey) }; NotificationCenter.default.post(name: .libraryDidChange, object: nil) }
}

enum Preferences {
    static var dark: Bool { get { UserDefaults.standard.bool(forKey: "blockside.dark") } set { UserDefaults.standard.set(newValue, forKey: "blockside.dark"); NotificationCenter.default.post(name: .themeDidChange, object: nil) } }
    static var username: String { get { UserDefaults.standard.string(forKey: "blockside.username") ?? "Player" } set { UserDefaults.standard.set(newValue, forKey: "blockside.username") } }
}
extension Notification.Name { static let themeDidChange = Notification.Name("BlocksideThemeDidChange") }
