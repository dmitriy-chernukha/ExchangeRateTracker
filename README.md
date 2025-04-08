# ExchangeRateTracker

# Overview

This test project was developed using Swift, SwiftUI, Combine, and Structured Concurrency. The primary goal was to build a clean, modular, and scalable application architecture that allows easy extension and maintainability, while delivering an efficient and modern user experience.

# Technologies and Architecture

- SwiftUI: Used for building a reactive, modern user interface compatible with light and dark modes.
- Combine: Adopted for reactive bindings between models and views.
- Structured Concurrency: Employed to manage asynchronous tasks safely and efficiently.
- MVVM Architecture: Separates data handling, business logic, and UI to improve testability and maintainability.
- Repository Pattern: Handles network communication and local caching with a clean abstraction.
- Protocol-Oriented Programming: Enhances modularity, flexibility, and testability.
- UserDefaults Caching: Used for offline support by persisting the last known rates.
- XCTest: Used for both unit and UI testing.

# Project Structure

## Network Layer

The network layer is structured for clarity and flexibility:

- Endpoints: Enum-based endpoint definitions for currency and crypto APIs.
- APIEndpoint Protocol: Defines baseURL, path, method, headers, and query parameters.
- NetworkService: A generic service that handles API requests using `URLSession` and decodes responses into typed models.

## Repository Layer

The repository layer abstracts networking and caching:

- CurrencyRepository: Fetches latest fiat exchange rates and caches them. Falls back to cached data when network fails.
- CryptoRepository: Fetches real-time crypto prices from CryptoCompare and caches results. Calculates 24-hour change when available.
- Protocol-Based CacheService: Stores and loads any Codable data using injected storage (e.g., UserDefaults or in-memory mocks for tests).

## Caching

- CacheService: A concrete implementation of a simple key-value caching mechanism using `UserDefaults`.
- InMemoryCache: Lightweight, test-friendly alternative for mocking persistent storage in unit tests.
- ExchangeItem Cache Keys: Cached separately for currencies and cryptocurrencies, cleaned when assets are removed.

## ViewModels

ViewModels in the app coordinate data flow between repositories and views:

- ExchangeRatesViewModel: Loads and refreshes combined currency/crypto items, manages offline cache loading and periodic updates.
- AddAssetViewModel: Manages searchable asset list and selected items, persists selections, and synchronizes with cached data.

## Views

- ExchangeRatesView: The main dashboard that displays live exchange rates, grouped by asset type, with support for swipe-to-delete, pull-to-refresh, and visual state handling.
- AddAssetView: A searchable asset selection view with split sections (popular currencies, cryptocurrencies). Supports adding/removing items with state persistence.
- ExchangeRateRowView: A clean, reusable UI component representing each currency or crypto item.

# Features

## Core Functionality

- View real-time exchange rates for both fiat currencies and cryptocurrencies.
- Auto-refresh every 3 seconds with smooth UI updates.
- Persistent asset selection stored between sessions.
- Offline support by falling back to last known cached rates.
- Swipe-to-remove with confirmation alert.
- Searchable asset list in `AddAssetView` for quickly finding currencies and crypto.
- Add new assets via a searchable full-screen modal view.
- Dark and light mode support.
