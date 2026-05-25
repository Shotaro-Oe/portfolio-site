import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: ChecklistStore
    @State private var showingAddPreset = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.presets) { preset in
                    NavigationLink(destination: ChecklistView(preset: preset)) {
                        PresetRowView(preset: preset)
                    }
                }
                .onDelete { store.deletePreset(at: $0) }
            }
            .navigationTitle("撮影機材チェックリスト")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPreset = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddPreset) {
                AddPresetView()
            }
        }
    }
}

struct PresetRowView: View {
    let preset: Preset

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: preset.icon)
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(preset.name)
                    .font(.headline)

                HStack(spacing: 6) {
                    ProgressView(value: preset.progress)
                        .frame(width: 100)
                        .tint(preset.progress == 1 ? .green : .accentColor)

                    Text("\(preset.checkedItems)/\(preset.totalItems)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if preset.progress == 1 {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 4)
    }
}
