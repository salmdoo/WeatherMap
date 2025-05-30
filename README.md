
## Project Overview
As a mapping company, the ability to display information effectively on a map is paramount. For this project you will fetch weather station data and display those stations as points on a map.

The weather station data is contained in two hosted JSON files (links below). The first JSON file contains forecast data for weather stations reporting ‘today’, the other contains forecast data for weather stations reporting ‘tomorrow’. In the context of this app, launch/wake time is always ‘today’.

# Core Functionality Requirement
Using UIKit or SwiftUI, shoot for adding the following functionality:
* Display a MapKit map on screen
  * Target iOS 16.
  * Builds for the iPhone. Supporting an iPad is not required.
  * Center your map on 40°55‘26.40"N 108°05’43.80”W 
  * Make your map span 25°Δ latitude and 20°Δ longitude (Hint: MKCoordinateSpan).
* Consume and parse weather station data (Treat endpoints as if they're not serving static data).
  * Today’s Station Data ([Link](https://gist.githubusercontent.com/rcedwards/4ff0a1510551295be0ec0369186d83ed/raw/fc7b5308546c0e1085d8748134138cef4281ac11/today.json))
  * Tomorrow’s Station Data ([Link](https://gist.githubusercontent.com/rcedwards/6421fa7f0f3789801935d6d37df55922/raw/e673021836819aa20018853643c8769fd4d129fd/tomorrow.json))
* Create and add to the map a MapKit annotation only for each station within the visible map area (this is contrary to Apple’s documentation which states to add all annotations even if not currently in view.).
  * The annotation should show the weather station’s current temperature, if available, else blank.
* After the user pans or zooms the map, filter and update the current set of annotations to be only those that are visible in the newly displayed map region. You may opt to continuously update the set of annotation during a map interaction, or opt to update only after the interaction ends. 
* Add a UI element that toggles between today’s and tomorrow’s station data data.
* Add a callout view with station/condition details when tapping on a station.

### Screenshots
| | | |
|----------|----------|----------|
| <kbd>![Untitled](https://github.com/user-attachments/assets/0b2ac233-b18a-496e-8c5d-01eb58cab822)</kbd> | <kbd>![Station details](https://github.com/user-attachments/assets/0599dfc4-ed17-4ba0-8925-150b3a138d13)</kbd> | <kbd>![Offline access](https://github.com/user-attachments/assets/86ffdff3-ed31-4851-99bc-2f3ba31ef687)</kbd> |

---

## Main Features

- **Interactive Map**: Displays weather stations as annotations using MapKit, centered on a specific region.
- **Data Toggle**: Switch between today's and tomorrow's weather data.
- **Dynamic Filtering**: Only stations within the visible map area are shown, updating as the user pans or zooms.
- **Station Details**: Tap a station to view detailed weather information in a callout view.
- **Condition Toggle**: Switch annotation display between temperature, wind speed, wind direction, and precipitation chance.
- **Offline Support**: Persist and load station data for offline use via Core Data and in-memory caching.
- **Unit Tests**: Includes unit tests for core ViewModel logic and services.
- **Responsive UI**: Supports device rotation and adapts to different screen sizes.

---

## Non-Functional Requirements

- **Performance**: Efficient filtering and annotation updates for smooth map interactions.
- **Reliability**: Graceful error handling for network failures and data issues.
- **Maintainability**: Modular code structure with clear separation of concerns (MVVM, services, caching).
- **Scalability**: Easily extendable to support more weather data types or additional features.
- **Usability**: Intuitive UI with segmented controls and clear feedback for loading and errors.
- **Testability**: Mock services and ViewModels for robust unit testing.

---

## Technologies Applied

- **Swift 5** and **SwiftUI** for modern, declarative UI development.
- **MapKit** for map rendering and annotation management.
- **Combine** for reactive data flow and asynchronous operations.
- **Core Data** for persistent offline storage.
- **NSCache** and custom in-memory caching for fast, temporary data access.
- **XCTest** for unit testing.
- **MVVM Architecture** for separation of UI and business logic.
- **Network Framework** for connectivity monitoring.

---

## Best Practices Highlighted

- **MVVM Pattern**: Clear separation between UI (`View`), state/logic (`ViewModel`), and data/services.
- **Dependency Injection**: Services are injected into ViewModels for flexibility and testability.
- **Combine for Async**: Uses Combine publishers for all async data flows, enabling easy composition and error handling.
- **Error Handling**: Centralized error types with user-friendly messages.
- **Efficient Caching**: Uses both in-memory (`NSCache`, dictionary) and persistent (Core Data) caching for performance and offline support.
- **SwiftUI Previews**: Provides preview code for rapid UI iteration.
- **Unit Testing**: Includes mocks and tests for ViewModel logic and service layers.
- **Code Modularity**: Organized into logical folders (Model, View, ViewModel, Service, Network, Caches).
- **Swift Language Features**: Leverages protocols, extensions, and generics for reusable, type-safe code.
- **Accessibility & Responsiveness**: UI adapts to orientation changes and different device sizes.
