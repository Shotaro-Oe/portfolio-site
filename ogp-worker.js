// ============================================================
//  Launch. OGP Worker — Cloudflare Workers
//  ルート設定: launch-films.com/work*
//
//  新作品追加時は WORKS に1行追記するだけでOK
// ============================================================

const WORKS = {
  'Bzf7EDiDhew': 'you-to「Rainbow Dream」MV',
  'H0g-1gybDJw': '川岸畜産様 社長密着ドキュメンタリー',
  '_Zw2gbwOdrg': '神戸観光タクシー ポートグループ PR映像',
  'jYZN9irRYTk': 'Juster「Hangry」MV',
  'l_Af4hLnry0': 'Genesis Augmented Reality',
  'GgmS1CXq54Y': '猫背のネイビーセゾン「MONOTARINAI」MV',
  'XWLQKS59xxA': 'shu「探し物」MV',
  'zypF-yAFEqI': 'ジンバジ「灯」MV',
  'YAT6KenzrBk': '2106 from Summer Christmas -「カウンターカルチャー」MV',
  'JaNb-H6OIqg': '都若丸「花咲せ」MV',
  'O4Ea7N0h1Hg': 'すいらん「アイラブユー」MV',
  'dA14ILze64U': 'HIGH SPY DOLL「愛しい君へ」MV',
  'hF4R6-bfg7M': 'LUDENS「Yellow」MV',
  'IbaMGMUA1qk': 'アンスリューム「擬似恋愛させたげるっ！」MV',
  'HkDQjjbLm6o': 'ジンバジ「おさんぽ」MV',
  'vSd7XBJmUWo': 'ジンバジ「今からは」MV',
  '3tgqSp5cTGE': 'ジンバジ「あの空には」MV',
  '5kCyAEQvFP0': 'ブロチ「Night Trip」MV',
  'T7LjjGe5jls': 'ジンバジ「気が付けば」MV',
  'IWRXq8qwDtY': 'タケヤキ翔「Hello Hello」MV',
  'oJiYaKzOonM': 'ピラフ星人「タメ口」MV',
};

export default {
  async fetch(request) {
    const url = new URL(request.url);
    const id  = url.searchParams.get('id');

    // id なし・未登録 → そのままページを返す
    const response = await fetch(request);
    if (!id || !WORKS[id]) return response;

    const title = WORKS[id] + ' — Launch.';
    const image = `https://img.youtube.com/vi/${id}/maxresdefault.jpg`;
    const desc  = `Launch. の作品 — ${WORKS[id]}`;

    return new HTMLRewriter()
      .on('title', {
        element(el) { el.setInnerContent(title); }
      })
      .on('meta[property="og:title"]', {
        element(el) { el.setAttribute('content', title); }
      })
      .on('meta[property="og:image"]', {
        element(el) { el.setAttribute('content', image); }
      })
      .on('meta[property="og:description"]', {
        element(el) { el.setAttribute('content', desc); }
      })
      .transform(response);
  }
};
