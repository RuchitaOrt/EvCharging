'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "4b4ad61cd70393e097bb1b34cd23cb4e",
"assets/AssetManifest.bin.json": "625122e40d56cbde33758bc74bb4f209",
"assets/AssetManifest.json": "11c1ab3c297f17b073f1cf282aa3e695",
"assets/assets/API-Configuration.json": "6b728072cf76f1e2d3732796585c6c25",
"assets/assets/images/alert.png": "a7ef0e69a550faec296eff95fe2f814c",
"assets/assets/images/apple.png": "af6b8451b3b076fd00e939e019d78507",
"assets/assets/images/apple.svg": "d54369cfe5fc96fd1d9b815765070d1a",
"assets/assets/images/arrowup.png": "7adb5711b6c967968431edc134a8a711",
"assets/assets/images/arrowup.svg": "5f4671425bd7bb784cafe9f64eab6a3f",
"assets/assets/images/back.png": "314539d1b43b6721cc9869d38f29450a",
"assets/assets/images/battery.svg": "741a20643721a1e5088054432d08b0e8",
"assets/assets/images/call.png": "a12f0af231fe6a1fcf0f066567fe007f",
"assets/assets/images/cancel.svg": "c97d9b91ad994931322307c22dafe364",
"assets/assets/images/car.png": "c31093f2375825d450ef0e4e252fa653",
"assets/assets/images/charger.png": "2e8e17a96fd8ad3ecac12b551b17bdae",
"assets/assets/images/chargingcomplete.png": "4de206aa2be3973416cc2298b196aeb6",
"assets/assets/images/chargingHistory.png": "20d263074f72e97e4e57ac0bf21bace2",
"assets/assets/images/chatting.png": "4d7009f95f3419e25c1e14d85185b0b8",
"assets/assets/images/check.png": "5dd7be8f1a4fbc0d4719f5b4f72c5fe8",
"assets/assets/images/check.svg": "a35f4338e421a406b207e453937f4de2",
"assets/assets/images/clock.png": "db686fce4ac38e622f7af8d03860db08",
"assets/assets/images/closecircle.png": "ac2678a453355c5d5ffc120088b7776a",
"assets/assets/images/coffee.svg": "a16ccfb9f7c73d3314124b595861caee",
"assets/assets/images/currency.svg": "8923d6aa9ae34acba6d03a403715ffb7",
"assets/assets/images/currentMarker.png": "ca4ef89d25597d9482b7a3cd2b89586a",
"assets/assets/images/delete.png": "13ff7c74ed32524dab569212a12efe1a",
"assets/assets/images/direction.svg": "34524eed2cc2da02c8d7602ac72f54ea",
"assets/assets/images/download.png": "3817e3a6b7716b7ca84869e53fb1203e",
"assets/assets/images/dropdown.svg": "e3aca836629e17f64fd66be1568a92f8",
"assets/assets/images/dropup.svg": "58c06cd94892a39aaef968abb1580840",
"assets/assets/images/edit.png": "8d29fc82e52ed4396d692cfa74d85e9f",
"assets/assets/images/faq.png": "9e47cd8d738e050f0ffd6fe8a85693be",
"assets/assets/images/filter.png": "91a900459e28de71126db3aa264ada14",
"assets/assets/images/filter.svg": "6b14f3f102eeb902c069925e2c60ea57",
"assets/assets/images/firstscreen.png": "26d5c0d967829d4e80c4cdcf7d494e11",
"assets/assets/images/firstscreenold.png": "03e7403c6ba470aab3d9843c16fc84b2",
"assets/assets/images/frame.png": "1dd59473560e319d11f2f6561083ae7c",
"assets/assets/images/google.png": "0eb8078198b32ac9d48f60dc38d16bc3",
"assets/assets/images/google.svg": "a5840eea0a96c31b1027433748518b66",
"assets/assets/images/greencharge.png": "0da7876ed30d81b7fcf29ffbb54e5343",
"assets/assets/images/greydirection.svg": "76fe17ce3dbc24d18663793010896b5a",
"assets/assets/images/help.png": "6cf6eb98581bf3248db3512ad1de2c65",
"assets/assets/images/info.svg": "b310455f6a29b8be2c28cdb453571bf4",
"assets/assets/images/location.png": "56894f89168d564c63307287c41fd64e",
"assets/assets/images/lock.png": "de5e381bde19af48f0bedb4b84a088cf",
"assets/assets/images/logo.png": "a973fbfd41e128d22ad880f0f626212e",
"assets/assets/images/logo.svg": "45c57bf5ab8717ac09736ec43d6438ab",
"assets/assets/images/logoold.png": "1bcced5156cb4ff1a89c8ae75a7b2318",
"assets/assets/images/logout.png": "d1781f94e6fa57b1fe9664a4c9f1efdd",
"assets/assets/images/mail.png": "d4d271ff20e023921575d76a2eafe250",
"assets/assets/images/map.svg": "08b08c9cce2c8ef7c5706fec5b82b9d7",
"assets/assets/images/normalMarker.png": "f8f9c570ec4fac729ef25aa4dc792e3d",
"assets/assets/images/notification.png": "9b3c5ba60b1c78bafc4bae174896878a",
"assets/assets/images/onboard1.svg": "47d8913b9c4d037bc3620045864745bb",
"assets/assets/images/onboard2.svg": "5a3d4580ff52e3f7a7b08c460aea3c8c",
"assets/assets/images/onboard3.svg": "a43f48e9339787097537859d79fa4500",
"assets/assets/images/onboard4.svg": "776c7e3e5508f592b27b0d6c8b8da362",
"assets/assets/images/paymentOption.png": "756d82bfbd6151416e9eaeca26b5a065",
"assets/assets/images/poweroutput.svg": "859ffd8162ba17eb4974e304d195dde0",
"assets/assets/images/product.png": "359f729cd7664b438c70321c6d02ec7a",
"assets/assets/images/product.svg": "865ced0ee9a37f930a81125c5323958c",
"assets/assets/images/profile.png": "acc72f00c280c3d7cdfca5cdf2134273",
"assets/assets/images/profile.svg": "82a6e5c597b94473b1d226c0aa26d2a4",
"assets/assets/images/profileIcon.png": "5fe2ca4ba94385304fd42b5fd3ebc83e",
"assets/assets/images/qr.png": "eec7e62c0d6f6532a6060827f6752af3",
"assets/assets/images/redpin.png": "4397c2cc6122c4188018113558263f58",
"assets/assets/images/scanner.svg": "551ffc5705aa0025e608226770863e17",
"assets/assets/images/setting.png": "e611bc8512c39da85830700424a85223",
"assets/assets/images/share.png": "d9db2e94760460a32d50bc8a45138381",
"assets/assets/images/shield.png": "54a238734c2bd0e078201bbc301ebb57",
"assets/assets/images/specialoffer.png": "c8a895c10de5ef28aff85196c0741ef5",
"assets/assets/images/splashlogo.svg": "d366b84a298b701078e14ca939843590",
"assets/assets/images/star.png": "8e3660a47c2db91c279b4c39286489c8",
"assets/assets/images/station.svg": "c3d5e466f1c65230af1eb29b5c5a63d0",
"assets/assets/images/swipe.png": "31a70d3a0d27e55c861015438707e9bd",
"assets/assets/images/targetMarker.png": "2fe6771f87859ec9c689f42c9801292e",
"assets/assets/images/thunder.svg": "acd8ef28dbccc58f68bbc94512a25a30",
"assets/assets/images/transactions.svg": "03e761f5b54d432724b001d9e873a0fd",
"assets/assets/images/triplearrow.svg": "0ccbfd9a37de5bf194d3bc783a8cfad8",
"assets/assets/images/unit.svg": "893e26a5ad073621793a2222f9a8c81e",
"assets/assets/images/upload.png": "0ec4d995c8d6b9b3ef556aa12a05839f",
"assets/assets/images/veh1.png": "adb98c57463231e902de8cd585f82e28",
"assets/assets/images/veh2.png": "7010de115312c5c3a39d329afd2c46b8",
"assets/assets/images/veh3.png": "f598e05f2651d039f3d07c31c635a14d",
"assets/assets/images/veh4.png": "b7efc28119a5f7d467ca89799ea7c711",
"assets/assets/images/vehicle.png": "783570d5b0729da471e61a96de404144",
"assets/assets/images/washroom.svg": "a60c7b2e94b5455c08c5d71787a8a0a3",
"assets/assets/images/wifi.svg": "7fe17510575d94bf0f1fe25bf90b130c",
"assets/assets/lottie/animationCharger.json": "982d4648e79e6fe2c2aa132fdc01c165",
"assets/assets/map_styles/dark_map.json": "ac55fab12e579cbb14128ba6c62e8648",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "8cae51a2025fb5e63f27c12294e5e9cd",
"assets/NOTICES": "f8613b7ce66aaef3525a3a7906570d8a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.ico": "a09336d748635f39232554dd24fd90c5",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "c6e2d3306a7520f0a534d509902d41c8",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "493e47e73c8a79c9ef35c9369a66d67a",
"/": "493e47e73c8a79c9ef35c9369a66d67a",
"main.dart.js": "ee105f63f47ec0760820d886a35fc4c0",
"manifest.json": "f09ef184879128e18a43b2971a461572",
"splash/img/dark-1x.png": "96cd2aa351fa7a08c281aeaec888093d",
"splash/img/dark-2x.png": "91cda7d0efdd442e2f00336303354971",
"splash/img/dark-3x.png": "ae984c44d71ca5eaef119b12249c1852",
"splash/img/dark-4x.png": "4da306a4b16ebaf59d21219275fc75ef",
"splash/img/light-1x.png": "96cd2aa351fa7a08c281aeaec888093d",
"splash/img/light-2x.png": "91cda7d0efdd442e2f00336303354971",
"splash/img/light-3x.png": "ae984c44d71ca5eaef119b12249c1852",
"splash/img/light-4x.png": "4da306a4b16ebaf59d21219275fc75ef",
"splash/splash.js": "d6c41ac4d1fdd6c1bbe210f325a84ad4",
"splash/style.css": "66b4f492954a35a3e8ab906c1bbc7904",
"version.json": "89544465f11bd3382450bb886df50405"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
  for (var resourceKey of Object.keys(RESOURCES)) {
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
