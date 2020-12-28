'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "5ed7d8620303c25bf8782f4aac2319db",
"assets/assets/images/logo.png": "a3659a5eb6439d373907c18b9aedd114",
"assets/assets/images/platillos/chocotorta.jpg": "5427e633d9b7b7cef5593b1585bf6085",
"assets/assets/images/platillos/empanadas-argentinas.jpg": "c7a3f25156e3f412ab056628dba7e280",
"assets/assets/images/platillos/empanadas-salvadorenas.jpg": "bae8b9b3669d07f9bdace55f951ff451",
"assets/assets/images/platillos/escabeche-salvadoreno.jpg": "d8f943abad92de7fddce2136ffb73a95",
"assets/assets/images/platillos/hacer-coctel-de-camaron.jpg": "82d77b60d85bcf47a2ce1d19eed9bcfc",
"assets/assets/images/platillos/pollo-empanizado.jpg": "28c9b105bf3eef8224c637cd59790259",
"assets/assets/images/platillos/pupusas-de-pollo.jpg": "5f0d431b90e40196129e779cfccee942",
"assets/assets/images/platillos/salsa-criolla-argentina-foto-principal.jpg": "3a0c4aff7b57ad6a61a584db9ac0bc1b",
"assets/assets/images/platillos/sopa-de-tortillas.jpg": "544ba516391eb1986e547f4125ff48f2",
"assets/assets/images/usuarios/img1.jpg": "487861c92efcd0bb4d7a45e9f4a386d8",
"assets/assets/images/usuarios/img10.jpg": "cc1516d887bb6d7c98dd57ebe3484460",
"assets/assets/images/usuarios/img11.jpg": "ffa956f4d957829a9e8040903a5d2017",
"assets/assets/images/usuarios/img12.jpg": "67773c4f4858ab1dc7dc43280d49a07a",
"assets/assets/images/usuarios/img13.jpg": "1edfc5561bed87a53e25c37f66baa846",
"assets/assets/images/usuarios/img14.jpg": "1c7532205c6dee56ec95df1c375bcb3c",
"assets/assets/images/usuarios/img15.jpg": "d42657b2b479f298962ef243ec10c182",
"assets/assets/images/usuarios/img16.jpg": "a2e3d5ad5c9ffa2bd97be951caaadd61",
"assets/assets/images/usuarios/img17.jpg": "8daec333a15a3d0be8b47140927c1394",
"assets/assets/images/usuarios/img18.jpg": "8be3666d146e1da728bf4c0d0e22d79d",
"assets/assets/images/usuarios/img19.jpg": "dfe1dd056ae94448cca6bec5a41e6b19",
"assets/assets/images/usuarios/img2.jpg": "ad7ab8955d11a2633d0445532446dd43",
"assets/assets/images/usuarios/img20.jpg": "6eb9089296d399d5444e9aef5148891f",
"assets/assets/images/usuarios/img21.jpg": "ad17f57008799d1bfdb177a04efff49d",
"assets/assets/images/usuarios/img3.jpg": "6669f7a3674532557c8c50f9eca29aa7",
"assets/assets/images/usuarios/img4.jpg": "7c9773b2a0a90481ffb73df005adc897",
"assets/assets/images/usuarios/img6.jpg": "f46c2cbaffd1bd65185a9ba57af282be",
"assets/assets/images/usuarios/img7.jpg": "b628ca593909348945f008d9fe431f54",
"assets/assets/images/usuarios/img8.jpg": "11686717e1469878092a9f6454c0b55e",
"assets/assets/images/usuarios/img9.jpg": "aaee998167f1bcde1af616a419758240",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/NOTICES": "c9fba7226fc095feb50502303596864b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "ca06f5026f33c85ba6b78136f1073699",
"/": "ca06f5026f33c85ba6b78136f1073699",
"main.dart.js": "66e99f0fc229f3a96b157e0d46207f06",
"manifest.json": "db34724ef7d6b6d314b23406443a4fba",
"version.json": "0de97551fa1e0d54bf808240a41f7ec3"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey in Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
