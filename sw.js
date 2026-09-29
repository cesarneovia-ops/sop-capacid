const CACHE = 'sop-capacidade-v22-pdfcards-2';
const ASSETS = ['index.html', 'manifest.json', 'icons/icon-192.png', 'icons/icon-512.png', 'icons/apple-touch-icon.png'];
self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).then(()=>self.skipWaiting()));
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k)))).then(()=>self.clients.claim()));
});
self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);
  if (url.origin !== location.origin) return;
  // HTML: rede primeiro, para pegar atualizacoes; offline cai no cache
  if (e.request.mode === 'navigate' || url.pathname.endsWith('.html')) {
    e.respondWith(fetch(e.request).then(r => {
      const clone = r.clone();
      caches.open(CACHE).then(c => c.put(e.request, clone));
      return r;
    }).catch(()=> caches.match(e.request).then(hit => hit || caches.match('index.html'))));
    return;
  }
  e.respondWith(caches.match(e.request).then(hit => hit || fetch(e.request).then(r => {
    const clone = r.clone();
    caches.open(CACHE).then(c => c.put(e.request, clone));
    return r;
  }).catch(()=> hit)));
});



