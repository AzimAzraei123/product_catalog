# Product Catalog App

A simple Flutter app that shows a list of products from the [DummyJSON](https://dummyjson.com) API. You can scroll through products, search for one, and tap on any product to see its full details.

## Stack

- Flutter 3.47.3
- Dart
- State management: I used Flutter's built-in `ChangeNotifier` instead of adding an extra library like Provider, Riverpod, or Bloc. 

## How to Run

### What you need first
- Flutter SDK installed on your computer
- Either an Android emulator, a physical phone, or you can just run it as a Windows/Chrome app

### Setup
```bash
git clone <your-repo-url>
cd product_catalog
flutter pub get
```
(`flutter pub get` downloads the extra packages the app needs, like `http` and `cached_network_image`.)

### Run the app
```bash
flutter run
```

**A quick note:** When I first set up this project, my installed Android Studio didn't support the newer Android build tools that Flutter uses by default. Instead of downgrading things and breaking other parts, I kept Flutter's normal settings and just added a flag that tells Flutter to skip that specific version check:
```bash
flutter run --android-skip-build-dependency-validation
```

### Run the tests
```bash
flutter test
```

## How the Code is Organized

I split the app into two main parts, so that the "getting data" code and the "showing data on screen" code don't get mixed together.

### `lib/data/` — everything about getting and understanding data
- `models/` — Simple classes that describe what a "Product" looks like (title, price, images, etc.), and know how to turn the raw text the API sends back into something my code can actually use.
- `services/` — The part that actually goes out and talks to the internet (calls the DummyJSON API). Its only job is: ask the API for data, and hand back the answer. It doesn't try to decide what to do if something goes wrong — it just reports it.
- `repositories/` — Sits just above the service and adds the "smart" decisions — like how many products to load per page, and how to know when we've reached the last page.

### `lib/presentation/` — everything about what the user sees
- `state/` — The "brain" of the main list screen. It keeps track of whether we're currently loading, showing an error, showing an empty result, or showing the products successfully. It also handles the search box waiting logic (explained below) and remembers what to do when you tap "Retry."
- `screens/` — The actual screens: the product list (with search and scrolling) and the product detail page.
- `widgets/` — Small reusable pieces, like a single product card, and the loading spinner / error message / empty message shown across both screens.

## A Few Choices I Made, and Why

- Search uses the real search API endpoint, not filtering on-device. If I only searched through the products already loaded on screen, someone searching "phone" might miss results that just haven't scrolled into view yet. Using the real search endpoint means it searches the *whole* catalog, not just what's currently loaded. The small tradeoff is it costs one more network call each time you search — which is why I added a short delay (see below) so it's not calling the API on every single keystroke.

- The list screen and the detail screen use different approaches.The list screen has to remember several things at once — how far you've scrolled, whether you're searching or browsing, a timer for the search box — so it made sense to give it its own dedicated "brain" (the controller). The detail screen is much simpler: it just needs to fetch one product and show it once, so I used a simpler built-in Flutter tool (`FutureBuilder`) instead of building a whole controller for it. Basically: I matched the complexity of the tool to the complexity of the actual problem, instead of using the same heavy approach everywhere.

- Scrolling loads more products automatically, instead of needing a "Load More" button — this matches how most shopping or feed apps behave, and directly satisfies the pagination requirement using the API's `skip` parameter.

- The search box waits before searching. Every time you type a letter, the app resets a short 400-millisecond timer. It only actually searches once you've stopped typing for that brief moment. This stops the app from sending a network request on every single keystroke while you're still typing.

## What the App Does When Things Go Wrong (or When There's No Data)

The main list screen can be in exactly one of four states at any time:
1. Loading — a spinner while data is being fetched
2. Error — an error message with a Retry button
3. Empty — a message saying no products were found
4. Success — the actual product grid

Tapping Retry redoes whatever you were last doing — if you were searching, it searches again; if you were just browsing, it reloads the list.

## Things I Didn't Finish / Known Limitations

- If loading more products (while scrolling) fails, the app just quietly keeps what it already has instead of showing an error for that specific case — you can still scroll and try again manually. Given the time-box for this assignment, I decided this was an acceptable gap rather than something worth spending extra time on.
- I mainly tested on Windows desktop , due to the Android Studio version issue mentioned above.
- No offline mode — if there's no internet at all, it will show the error screen rather than anything more specific.

## AI Usage

I used Claude (an AI assistant by Anthropic) while building this — mainly to talk through how to structure the project into layers, to help debug an Android build-tools version conflict I ran into during setup, and as a reference while writing the code for the models, services, repository, controller, and screens. I then typed it into the project myself, ran it, and tested it.