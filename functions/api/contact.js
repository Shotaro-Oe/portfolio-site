// Cloudflare Pages Function: POST /api/contact
// 必要な環境変数 (Cloudflare Pages > Settings > Environment variables):
//   RESEND_API_KEY : Resend の APIキー (Secret)
//   TO_EMAIL       : 問い合わせの受信先メールアドレス
//   FROM_EMAIL     : 送信元 (Resendで認証したドメインのアドレス。例: contact@launch-films.com)

const esc = (s) => String(s || '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

export async function onRequestPost({ request, env }) {
  let d;
  try { d = await request.json(); } catch { return new Response('bad request', { status: 400 }); }

  if (d.website) return new Response('ok', { status: 200 }); // honeypot

  const required = ['company', 'name', 'email', 'message'];
  for (const k of required) {
    if (!d[k] || String(d[k]).length > 3000) return new Response('invalid', { status: 400 });
  }
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(d.email)) return new Response('invalid', { status: 400 });
  if (!env.RESEND_API_KEY || !env.TO_EMAIL || !env.FROM_EMAIL) return new Response('not configured', { status: 500 });

  const html = `
    <h2>企業向けLP からお問い合わせ</h2>
    <p><b>会社名:</b> ${esc(d.company)}</p>
    <p><b>担当者:</b> ${esc(d.name)}</p>
    <p><b>メール:</b> ${esc(d.email)}</p>
    <p><b>予算:</b> ${esc(d.budget) || '未定'}</p>
    <p><b>希望納期:</b> ${esc(d.deadline) || '-'}</p>
    <p><b>相談内容:</b><br>${esc(d.message).replace(/\n/g, '<br>')}</p>`;

  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${env.RESEND_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      from: env.FROM_EMAIL,
      to: [env.TO_EMAIL],
      reply_to: d.email,
      subject: `【企業向けLP】${d.company} ${d.name}様よりお問い合わせ`,
      html
    })
  });

  return new Response(res.ok ? 'ok' : 'send failed', { status: res.ok ? 200 : 502 });
}
