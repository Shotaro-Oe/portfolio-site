import Foundation
import Combine

final class ChecklistStore: ObservableObject {
    @Published var presets: [Preset] = []

    private let saveKey = "camera_checklist_presets"

    init() {
        load()
        if presets.isEmpty {
            presets = Preset.defaults
        }
    }

    // MARK: - Preset operations

    func addPreset(_ preset: Preset) {
        presets.append(preset)
        save()
    }

    func deletePreset(at offsets: IndexSet) {
        presets.remove(atOffsets: offsets)
        save()
    }

    func resetChecks(in presetID: UUID) {
        guard let pi = presets.firstIndex(where: { $0.id == presetID }) else { return }
        for ci in presets[pi].categories.indices {
            for ii in presets[pi].categories[ci].items.indices {
                presets[pi].categories[ci].items[ii].isChecked = false
            }
        }
        save()
    }

    // MARK: - Item operations

    func toggleItem(presetID: UUID, categoryID: UUID, itemID: UUID) {
        guard let pi = presets.firstIndex(where: { $0.id == presetID }),
              let ci = presets[pi].categories.firstIndex(where: { $0.id == categoryID }),
              let ii = presets[pi].categories[ci].items.firstIndex(where: { $0.id == itemID })
        else { return }
        presets[pi].categories[ci].items[ii].isChecked.toggle()
        save()
    }

    func addItem(_ item: Equipment, presetID: UUID, categoryID: UUID) {
        guard let pi = presets.firstIndex(where: { $0.id == presetID }),
              let ci = presets[pi].categories.firstIndex(where: { $0.id == categoryID })
        else { return }
        presets[pi].categories[ci].items.append(item)
        save()
    }

    func deleteItem(presetID: UUID, categoryID: UUID, at offsets: IndexSet) {
        guard let pi = presets.firstIndex(where: { $0.id == presetID }),
              let ci = presets[pi].categories.firstIndex(where: { $0.id == categoryID })
        else { return }
        presets[pi].categories[ci].items.remove(atOffsets: offsets)
        save()
    }

    func addCategory(_ category: Category, presetID: UUID) {
        guard let pi = presets.firstIndex(where: { $0.id == presetID }) else { return }
        presets[pi].categories.append(category)
        save()
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(presets) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Preset].self, from: data)
        else { return }
        presets = decoded
    }
}
