# KSTA Flutter News App

A Flutter case study for a recruitment process that recreates a modern, modular news experience on top of the KSTA content API.

The goal of the project was not just to render API data, but to turn a CMS-driven payload into a readable, responsive, editorial product with a deliberately small architecture, clear configuration boundaries, and production-minded handling for images, embeds, caching, and failure states.

## Project Goals

- Build a responsive news app in Flutter for web and mobile.
- Translate a block-based homepage API into reusable UI sections.
- Keep the architecture lightweight and easy to reason about for a case-study scope.
- Handle external configuration cleanly instead of hardcoding environment-specific values.
- Make the UX feel editorial rather than like a generic API demo.

## What the App Supports

- Homepage assembled from API-driven content blocks.
- Multiple homepage presentations:
  - hero
  - three-up
  - ranked
  - carousel
  - mixed
  - embed/free HTML
  - generic fallback for unknown layouts
- Article detail page with:
  - headline, breadcrumbs, metadata, intro text
  - lead image and inline images
  - paragraph rendering
  - related article modules
  - estimated reading time
- Responsive layout behavior for compact, medium, and expanded breakpoints.
- Light and dark mode with persisted user preference.
- Pull-to-refresh on the homepage.
- Error and loading states for both full-page and section-level content.
- Platform-aware handling for external embeds.

## Implementation Decisions

### 1. Lightweight architecture over heavy abstraction

I intentionally kept the architecture small and explicit:

- `AppConfig` validates required runtime configuration at startup.
- `HomepageRepository` is responsible for remote data access.
- `ArticlePreviewStore` and `AuthorStore` cache fetched entities and deduplicate in-flight requests.
- `HomepageController` and `HomepageBlockController` manage view state with `ChangeNotifier`.
- `ListenableBuilder` keeps the UI reactive without introducing a heavier state-management dependency for a case study of this size.

This keeps the codebase easy to follow in an interview setting while still separating concerns properly.

### 2. Lazy hydration for better perceived performance

The homepage loads the page structure first, then each homepage block resolves its required article previews independently.

Why this approach:

- sections can render progressively instead of waiting for all teaser content at once
- cached articles can appear immediately on revisit
- failures are isolated to a single block rather than collapsing the entire homepage

This gives the app a more resilient and realistic newsroom-style loading behavior.

### 3. Request deduplication and caching

`ArticlePreviewStore` and `AuthorStore` maintain both:

- an in-memory cache for already fetched entities
- an in-flight request map so the same article/author is not requested multiple times concurrently

This reduces unnecessary API traffic and keeps related content hydration efficient.

### 4. Typed navigation

Routing is implemented with `go_router` typed routes instead of stringly typed navigation.

Why:

- safer route construction
- cleaner navigation to article detail pages
- fewer runtime errors from malformed paths

### 5. Runtime configuration via `--dart-define-from-file`

The app expects environment values to be provided at runtime through a JSON config file.

That choice keeps secrets and environment-specific URLs out of source code and allows the same codebase to run in local, CI, and deployed environments with different configuration.

The app also fails fast on startup if required values are missing, which makes setup issues obvious immediately.

### 6. Signed, responsive image URLs

Images are not treated as plain static URLs.

The app:

- resolves image paths against the configured image host
- applies breakpoint-aware image presets
- signs requests with the configured Imgix secret
- strips existing signatures before rebuilding a clean signed URL

This was an intentional decision to reflect real-world media delivery concerns such as optimization, consistency, and protected image access.

### 7. Editorial UI instead of default Flutter styling

The design system uses:

- Material 3 as the base
- custom color palettes for light and dark mode
- `Merriweather` for headline typography
- `Source Sans 3` for readable body and interface copy

The aim was to create a product that feels closer to a publisher brand than a default Flutter starter app.

### 8. Practical embed handling

Embedded content is handled separately from regular article blocks and includes:

- consent gating when required
- loading and retry states
- adaptive embed height
- desktop interaction locking for safer inline scrolling behavior

That makes embedded content usable without letting it degrade the rest of the homepage experience.

## Trade-offs

Because this was implemented as a focused case study, I optimized for clarity and product quality over exhaustive platform infrastructure.

Intentional trade-offs:

- no heavyweight DI or state-management framework
- no authentication flow, because the scope is public content delivery
- no full HTML renderer for article bodies; the article page supports the content blocks required for this exercise
- automated tests are the next logical step, but were not included in this iteration

If this were extended further, I would prioritize repository/controller tests, image-signing tests, and widget tests for the main homepage/article flows.

## Tech Stack

- Flutter
- Dart
- `go_router`
- `http`
- `shared_preferences`
- `webview_flutter`
- `google_fonts`
- `skeletonizer`
- `flutter_svg`

## Project Structure

```text
lib/
  app/                App bootstrap and dependency initialization
  config/             Runtime config validation
  data/
    news/             API models, repository, stores, mapping
    utils/            API/request helpers and exceptions
  pages/
    home/             Homepage controllers and block-based UI
    article_detail/   Article detail screen and content widgets
  router/             Typed app routing
  theme/              Light/dark theme and theme persistence
  widgets/            Shared UI components
  utils/              Breakpoints and input helpers
configs/
  config.example.json Example runtime config
```

## Local Setup

### Prerequisites

- Flutter SDK installed
- Dart SDK compatible with the Flutter version in use
- A valid Imgix secret for image signing

This project has been set up and deployed with Flutter `3.41.4`, and the Dart SDK constraint in `pubspec.yaml` is `>=3.11.1 <4.0.0`.

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Create the local config file

Copy the example config:

```bash
cp configs/config.example.json configs/config.dev.json
```

`configs/config.dev.json` is gitignored on purpose and should stay local.

### 3. Add the required secret and config values

Open `configs/config.dev.json` and provide the real values:

```json
{
  "base_url": "https://www.ksta.de/__content-api/",
  "image_base_url": "https://static.ksta.de/__images/",
  "imgix_secret": "REPLACE_WITH_THE_PROVIDED_IMGIX_SECRET"
}
```

Notes:

- `base_url` is the content API base URL.
- `image_base_url` is the image host used to resolve media paths.
- `imgix_secret` is required so the app can generate valid signed image URLs.

Without the correct `imgix_secret`, the app can still start, but article and teaser images will not load correctly.

### 4. Run the project locally

```bash
flutter run --dart-define-from-file=configs/config.dev.json
```

For web specifically:

```bash
flutter run -d chrome --dart-define-from-file=configs/config.dev.json
```

## Build Commands

### Local production-style web build

```bash
flutter build web --release --dart-define-from-file=configs/config.dev.json
```

### Static analysis

```bash
flutter analyze
```

## Deployment Note

The repository already includes a GitHub Pages workflow.

CI expects a repository secret named `CONFIG_DEV_JSON` that contains the full JSON contents of `configs/config.dev.json`. During the workflow, that secret is written to `configs/config.dev.json` before building the web app.

This keeps the required runtime configuration out of the repository while still allowing automated deployment.

## Why This Case Study Reflects My Approach

This project is a good representation of how I like to build:

- start with a clean, understandable architecture
- make product decisions visible in the code
- choose simple tools when the scope allows it
- handle edge cases like loading, failure, caching, and configuration explicitly
- keep the user experience polished even in a technical exercise

The result is intentionally not over-engineered, but it is structured to be extendable, reviewable, and realistic.
