import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var store: ChecklistStore
    @Environment(\.dismiss) var dismiss

    let presetID: UUID
    let categoryID: UUID

    @State private var name = ""
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("アイテム名") {
                    TextField("例: カメラボディ", text: $name)
                }
                Section("メモ（任意）") {
                    TextField("例: フル充電済みか確認", text: $note)
                }
            }
            .navigationTitle("アイテムを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") {
                        let item = Equipment(name: name, note: note)
                        store.addItem(item, presetID: presetID, categoryID: categoryID)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

struct AddCategoryView: View {
    @EnvironmentObject var store: ChecklistStore
    @Environment(\.dismiss) var dismiss

    let presetID: UUID

    @State private var name = ""
    @State private var icon = "folder.fill"

    let icons = [
        "camera.fill", "camera.aperture", "bolt.fill", "memorychip",
        "bag.fill", "mic.fill", "video.fill", "gyroscope",
        "cloud.rain.fill", "figure.stand", "folder.fill", "star.fill"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("カテゴリ名") {
                    TextField("例: 三脚・サポート", text: $name)
                }
                Section("アイコン") {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 6), spacing: 12) {
                        ForEach(icons, id: \.self) { iconName in
                            Button {
                                icon = iconName
                            } label: {
                                Image(systemName: iconName)
                                    .font(.title2)
                                    .foregroundStyle(icon == iconName ? .white : .accentColor)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(icon == iconName ? Color.accentColor : Color.accentColor.opacity(0.1))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("カテゴリを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") {
                        let category = Category(name: name, icon: icon, items: [])
                        store.addCategory(category, presetID: presetID)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

struct AddPresetView: View {
    @EnvironmentObject var store: ChecklistStore
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var icon = "camera.fill"

    let icons = [
        "camera.fill", "video.fill", "person.fill", "mountain.2.fill",
        "building.2.fill", "sportscourt.fill", "music.note", "star.fill"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("プリセット名") {
                    TextField("例: ウェディング撮影", text: $name)
                }
                Section("アイコン") {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 12) {
                        ForEach(icons, id: \.self) { iconName in
                            Button {
                                icon = iconName
                            } label: {
                                Image(systemName: iconName)
                                    .font(.title)
                                    .foregroundStyle(icon == iconName ? .white : .accentColor)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(icon == iconName ? Color.accentColor : Color.accentColor.opacity(0.1))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("プリセットを追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("追加") {
                        let preset = Preset(name: name, icon: icon, categories: [])
                        store.addPreset(preset)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
