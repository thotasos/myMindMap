import Foundation
import AppKit

/// Manages atomic file I/O with auto-backup for SwiftData stores
final class BackupManager: @unchecked Sendable {
    static let shared = BackupManager()

    private let fileManager = FileManager.default
    private let backupDirectoryName = ".backup"
    private let maxBackupCount = 10

    private init() {}

    /// Creates a timestamped backup before save
    func performBackup(for url: URL) throws {
        let backupDir = url.deletingLastPathComponent()
            .appendingPathComponent(backupDirectoryName)

        try fileManager.createDirectory(at: backupDir, withIntermediateDirectories: true)

        let timestamp = formatTimestamp(Date())
        let backupName = "backup_\(timestamp)"
        let backupURL = backupDir.appendingPathComponent(backupName)

        // Copy current to backup
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.copyItem(at: url, to: backupURL)
        }

        // Prune old backups
        pruneOldBackups(in: backupDir)
    }

    /// Restores from the most recent backup
    func restoreFromBackup(for url: URL) throws {
        let backupDir = url.deletingLastPathComponent()
            .appendingPathComponent(backupDirectoryName)

        guard let latestBackup = latestBackup(in: backupDir) else {
            throw BackupError.noBackupAvailable
        }

        // Remove corrupted file
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }

        // Restore from backup
        try fileManager.copyItem(at: latestBackup, to: url)
    }

    /// Lists available backups
    func listBackups(for url: URL) -> [URL] {
        let backupDir = url.deletingLastPathComponent()
            .appendingPathComponent(backupDirectoryName)

        guard let contents = try? fileManager.contentsOfDirectory(
            at: backupDir,
            includingPropertiesForKeys: [.creationDateKey],
            options: .skipsHiddenFiles
        ) else {
            return []
        }

        return contents
            .filter { $0.lastPathComponent.hasPrefix("backup_") }
            .sorted { url1, url2 in
                let date1 = (try? url1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                let date2 = (try? url2.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                return date1 > date2
            }
    }

    private func latestBackup(in directory: URL) -> URL? {
        listBackups(for: directory.appendingPathComponent("dummy.mindmap"))
            .first
    }

    private func pruneOldBackups(in directory: URL) {
        let backups = listBackups(for: directory.appendingPathComponent("dummy.mindmap"))

        if backups.count > maxBackupCount {
            let toRemove = backups.suffix(from: maxBackupCount)
            for backup in toRemove {
                try? fileManager.removeItem(at: backup)
            }
        }
    }

    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter.string(from: date)
    }

    /// Checks if a SwiftData store is corrupted
    func checkStoreIntegrity(at url: URL) -> Bool {
        guard fileManager.fileExists(atPath: url.path) else {
            return false
        }

        // Try to read the store file
        do {
            let data = try Data(contentsOf: url)
            // Check for minimum valid size (empty or too small is suspicious)
            return data.count > 100
        } catch {
            return false
        }
    }
}

enum BackupError: LocalizedError {
    case noBackupAvailable
    case backupFailed(String)

    var errorDescription: String? {
        switch self {
        case .noBackupAvailable:
            return "No backup available to restore from"
        case .backupFailed(let reason):
            return "Backup failed: \(reason)"
        }
    }
}
