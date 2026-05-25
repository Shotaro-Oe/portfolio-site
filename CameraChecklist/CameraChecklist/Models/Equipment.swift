import Foundation

struct Equipment: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var isChecked: Bool = false
    var note: String = ""
}

struct Category: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var icon: String
    var items: [Equipment]
}

struct Preset: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var icon: String
    var categories: [Category]

    var totalItems: Int {
        categories.reduce(0) { $0 + $1.items.count }
    }

    var checkedItems: Int {
        categories.reduce(0) { $0 + $1.items.filter(\.isChecked).count }
    }

    var progress: Double {
        totalItems == 0 ? 0 : Double(checkedItems) / Double(totalItems)
    }
}

extension Preset {
    static let defaults: [Preset] = [
        Preset(
            name: "ポートレート撮影",
            icon: "person.fill",
            categories: [
                Category(name: "カメラボディ", icon: "camera.fill", items: [
                    Equipment(name: "カメラボディ"),
                    Equipment(name: "予備バッテリー"),
                    Equipment(name: "バッテリーチャージャー"),
                ]),
                Category(name: "レンズ", icon: "camera.aperture", items: [
                    Equipment(name: "標準レンズ (50mm)"),
                    Equipment(name: "ポートレートレンズ (85mm)"),
                    Equipment(name: "レンズキャップ"),
                    Equipment(name: "レンズクロス"),
                ]),
                Category(name: "ストレージ", icon: "memorychip", items: [
                    Equipment(name: "SDカード (×2)"),
                    Equipment(name: "CFexpress カード"),
                ]),
                Category(name: "ライティング", icon: "bolt.fill", items: [
                    Equipment(name: "外付けフラッシュ"),
                    Equipment(name: "レフ板"),
                    Equipment(name: "ディフューザー"),
                ]),
                Category(name: "アクセサリー", icon: "bag.fill", items: [
                    Equipment(name: "カメラバッグ"),
                    Equipment(name: "ネックストラップ"),
                    Equipment(name: "リモートシャッター"),
                ]),
            ]
        ),
        Preset(
            name: "風景・旅行撮影",
            icon: "mountain.2.fill",
            categories: [
                Category(name: "カメラボディ", icon: "camera.fill", items: [
                    Equipment(name: "カメラボディ"),
                    Equipment(name: "予備バッテリー (×2)"),
                    Equipment(name: "バッテリーチャージャー"),
                    Equipment(name: "モバイルバッテリー"),
                ]),
                Category(name: "レンズ", icon: "camera.aperture", items: [
                    Equipment(name: "広角レンズ (16-35mm)"),
                    Equipment(name: "標準ズームレンズ (24-70mm)"),
                    Equipment(name: "望遠レンズ (70-200mm)"),
                    Equipment(name: "フィルター (ND, CPL)"),
                ]),
                Category(name: "三脚・サポート", icon: "figure.stand", items: [
                    Equipment(name: "三脚"),
                    Equipment(name: "雲台"),
                    Equipment(name: "ゴリラポッド"),
                ]),
                Category(name: "ストレージ", icon: "memorychip", items: [
                    Equipment(name: "SDカード (×4)"),
                    Equipment(name: "ポータブルSSD"),
                ]),
                Category(name: "天候対策", icon: "cloud.rain.fill", items: [
                    Equipment(name: "レインカバー"),
                    Equipment(name: "乾燥剤"),
                    Equipment(name: "クリーニングキット"),
                ]),
            ]
        ),
        Preset(
            name: "動画撮影",
            icon: "video.fill",
            categories: [
                Category(name: "カメラ・映像", icon: "camera.fill", items: [
                    Equipment(name: "カメラボディ"),
                    Equipment(name: "予備バッテリー (×3)"),
                    Equipment(name: "NP-F バッテリー"),
                ]),
                Category(name: "レンズ", icon: "camera.aperture", items: [
                    Equipment(name: "シネマレンズ"),
                    Equipment(name: "NDフィルター"),
                    Equipment(name: "ついばみリング"),
                ]),
                Category(name: "音声", icon: "mic.fill", items: [
                    Equipment(name: "ショットガンマイク"),
                    Equipment(name: "ラベリアマイク"),
                    Equipment(name: "ウィンドシールド"),
                    Equipment(name: "レコーダー"),
                    Equipment(name: "ヘッドフォン"),
                ]),
                Category(name: "スタビライザー", icon: "gyroscope", items: [
                    Equipment(name: "ジンバル"),
                    Equipment(name: "スライダー"),
                    Equipment(name: "流し撮りリグ"),
                ]),
                Category(name: "ライティング", icon: "bolt.fill", items: [
                    Equipment(name: "LEDパネル"),
                    Equipment(name: "ソフトボックス"),
                    Equipment(name: "カラーフィルター"),
                ]),
                Category(name: "ストレージ", icon: "memorychip", items: [
                    Equipment(name: "CFexpress (×2)"),
                    Equipment(name: "外付けSSD"),
                ]),
            ]
        ),
    ]
}
