import UIKit

class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad(); title = "Blockside"; tabBarItem.title = "Home"
        stack.addArrangedSubview(heading("Good to see you, \(Preferences.username)", subtitle: "Your Minecraft companion"))
        let hero = CardView(title: "BLOCKSIDE", body: "A home for your game files and worlds. Your library stays on this device.", icon: "◼")
        hero.backgroundColor = UIColor(red: 0.16, green: 0.34, blue: 0.23, alpha: 1); hero.titleLabel.textColor = .white; hero.bodyLabel.textColor = UIColor(white: 0.9, alpha: 1); hero.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true; stack.addArrangedSubview(hero)
        let play = ActionButton("PLAY", color: Palette.green); play.addTarget(self, action: #selector(playTapped), for: .touchUpInside); stack.addArrangedSubview(play)
        stack.addArrangedSubview(card("Game engine not connected", body: "This app manages launcher screens and local files. It does not include Minecraft or a compatible runtime, so it cannot launch a playable game.", icon: "ℹ️"))
        stack.addArrangedSubview(card("Installed versions", body: "No playable installation is connected. iOS apps cannot scan another app’s private game files; imported files in this library are not game installations.", icon: "▦"))
        let worlds = LibraryStore.shared.entries.filter { $0.kind == .world }
        stack.addArrangedSubview(card("Worlds", body: worlds.isEmpty ? "No worlds imported yet. Add a supported .mcworld file from Library." : worlds.prefix(3).map { $0.name }.joined(separator: "\n"), icon: "🌍"))
        stack.addArrangedSubview(card("Quick status", body: "Offline profile · \(LibraryStore.shared.entries.count) local items · \(prettySize(LibraryStore.shared.sizeBytes())) used", icon: "⚙️"))
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .libraryDidChange, object: nil)
    }
    @objc private func playTapped() { showMessage("No playable engine", "Blockside is the launcher interface and local content manager only. It does not contain Minecraft or a supported iOS game runtime, so no game can be launched from this build.") }
    @objc private func refresh() { /* view reflects current library on next launch */ }
}
