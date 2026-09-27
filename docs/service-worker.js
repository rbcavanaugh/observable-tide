const CACHE = 'portland-tide-v2';
const OFFLINE_URL = './offline.html';

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE)
      .then(cache => cache.add(OFFLINE_URL))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(
        keys.filter(k => k !== CACHE).map(k => caches.delete(k))
      ))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  const { request } = event;
  const url = new URL(request.url);

  // Skip cross-origin requests (Google Fonts, etc.)
  if (url.origin !== self.location.origin) return;

  if (request.mode === 'navigate') {
    // Navigation: network first, cache fallback, offline page as last resort
    event.respondWith(
      fetch(request)
        .then(response => {
          caches.open(CACHE).then(cache => cache.put(request, response.clone()));
          return response;
        })
        .catch(() =>
          caches.match(request).then(cached => cached || caches.match(OFFLINE_URL))
        )
    );
  } else {
    // Assets (JS, CSS, data CSV): cache first, network fallback and store
    event.respondWith(
      caches.match(request).then(cached => {
        if (cached) return cached;
        return fetch(request).then(response => {
          if (response.ok) {
            caches.open(CACHE).then(cache => cache.put(request, response.clone()));
          }
          return response;
        });
      })
    );
  }
});
