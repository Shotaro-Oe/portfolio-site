import SwiftUI

struct ChecklistView: View {
    @EnvironmentObject var store: ChecklistStore
    let preset: Preset

    @State private var showingAddCategory = false
    @State private var showingResetAlert = false

    private var currentPreset: Preset {
        store.presets.first(where: { $0.id == preset.id }) ?? preset
    }

    var body: some View {
        List {
            Section {
                ProgressSummaryView(preset: currentPreset)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            ForEach(currentPreset.categories) { category in
                CategorySection(preset: currentPreset, category: category)
            }

            Section {
                Button {
                    showingAddCategory = true
                } label: {
                    Label("カテゴリを追加", systemImage: "folder.badge.plus")
                }
            }
        }
        .navigationTitle(currentPreset.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingResetAlert = true
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
        }
        .alert("チェックをリセット", isPresented: $showingResetAlert) {
            Button("リセット", role: .destructive) {
                store.resetChecks(in: preset.id)
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("すべてのチェックをリセットしますか？")
        }
        .sheet(isPresented: $showingAddCategory) {
            AddCategoryView(presetID: preset.id)
        }
    }
}

struct ProgressSummaryView: View {
    let preset: Preset

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: preset.progress)
                    .stroke(
                        preset.progress == 1 ? Color.green : Color.accentColor,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: preset.progress)

                VStack(spacing: 2) {
                    Text("\(Int(preset.progress * 100))%")
                        .font(.title.bold())
                    Text("\(preset.checkedItems)/\(preset.totalItems)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 110, height: 110)
            .padding(.top, 8)

            if preset.progress == 1 {
                Label("準備完了！", systemImage: "checkmark.seal.fill")
                    .font(.headline)
                    .foregroundStyle(.green)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
}

struct CategorySection: View {
    @EnvironmentObject var store: ChecklistStore
    let preset: Preset
    let category: Category

    @State private var showingAddItem = false
    @State private var isExpanded = true

    var body: some View {
        Section(isExpanded: $isExpanded) {
            ForEach(category.items) { item in
                ItemRowView(
                    item: item,
                    onToggle: {
                        store.toggleItem(
                            presetID: preset.id,
                            categoryID: category.id,
                            itemID: item.id
                        )
                    }
                )
            }
            .onDelete { offsets in
                store.deleteItem(presetID: preset.id, categoryID: category.id, at: offsets)
            }

            Button {
                showingAddItem = true
            } label: {
                Label("アイテムを追加", systemImage: "plus.circle")
                    .font(.subheadline)
                    .foregroundStyle(.accentColor)
            }
        } header: {
            HStack {
                Image(systemName: category.icon)
                Text(category.name)
                Spacer()
                let checked = category.items.filter(\.isChecked).count
                Text("\(checked)/\(category.items.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView(presetID: preset.id, categoryID: category.id)
        }
    }
}

struct ItemRowView: View {
    let item: Equipment
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isChecked ? .green : .secondary)
                    .animation(.spring(duration: 0.2), value: item.isChecked)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .foregroundStyle(item.isChecked ? .secondary : .primary)
                        .strikethrough(item.isChecked, color: .secondary)

                    if !item.note.isEmpty {
                        Text(item.note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
