// Cloudflare Pages Function: POST /api/contact-wedding
// 結婚式LP(wedding.html)用。環境変数は /api/contact と共通:
//   RESEND_API_KEY / TO_EMAIL / FROM_EMAIL

const esc = (s) => String(s || '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

export async function onRequestPost({ request, env }) {
  let d;
  try { d = await request.json(); } catch { return new Response('bad request', { status: 400 }); }

  if (d.website) return new Response('ok', { status: 200 }); // honeypot

  for (const k of ['name', 'email', 'message']) {
    if (!d[k] || String(d[k]).length > 3000) return new Response('invalid', { status: 400 });
  }
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(d.email)) return new Response('invalid', { status: 400 });
  if (!env.RESEND_API_KEY || !env.TO_EMAIL || !env.FROM_EMAIL) return new Response('not configured', { status: 500 });

  const html = `
    <h2>結婚式LP からお問い合わせ</h2>
    <p><b>お名前:</b> ${esc(d.name)}</p>
    <p><b>メール:</b> ${esc(d.email)}</p>
    <p><b>ご希望の映像:</b> ${esc(d.type) || '-'}</p>
    <p><b>挙式日(予定):</b> ${esc(d.date) || '-'}</p>
    <p><b>ご相談内容:</b><br>${esc(d.message).replace(/\n/g, '<br>')}</p>`;

  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${env.RESEND_API_KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      from: env.FROM_EMAIL,
      to: [env.TO_EMAIL],
      reply_to: d.email,
      subject: `【結婚式LP】${d.name}様よりお問い合わせ`,
      html
    })
  });

  return new Response(res.ok ? 'ok' : 'send failed', { status: res.ok ? 200 : 502 });
}
