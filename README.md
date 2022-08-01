# Events Package

## Overview

This package allow the app to set showcase various type of events for the ABO, Public events , Virtual events

After importing the package , we shall need to pass the required dependencies for this package to showcase the required data.
[Technical Diagram](https://www.figma.com/file/wmg5BjgD4sQzO7VuKtwMVp/Events-Package?node-id=0%3A1)
[Documentation](https://www.notion.so/ymedialabs/Events-Package-SwiftUI-4c95610e3aec440ea18c6d7fdfbfa513)

### Requirements

- iOS 14+
- SwiftUI

## Dependencies:
**External**: [Introspect](https://github.com/siteline/SwiftUI-Introspect.git)

**Internal**
There is a  AmwayGateway enum which is responsible for get all the events package dependencies from app and makeEventsOverview 
`makeEventsOverview(theme: .taiwan,provider: provider,router: router)` 

**Theme**: [AmwayThemeKit](https://www.notion.so/AmwayThemeKit-72fa1419e421481c99527db59f043a61).
Since events package screens are internally using fonts and colors from **AmwayThemeKit** package. we need to pass the theme acc to which we want to see fonts and colors.

**EventsDataProviderLogic**

The events provider facilitate communication between the controller from the UI layer and the services that are used to retrieve/persist data.This helps provide proper separation of concerns between the these objects.
Eg. 

**`func** fetchScheduledEvents(type: EventsDataFetchType) -> AnyPublisher<[ABOEventLogic], Error>` - responsible for providing dynamic api related data.

**`func** fetchEventsFields(fieldId: String) -> EventsOverViewFields?` - responsible for providing static data.

**EventsRoutingLogic**
The events router facilitate communication between the routing/Navigation from the this UI Layer package and the application navigation logic.
we shall receive the call from this abstraction in implementation class `EventsOverviewRouter` in our **app**. here we can decide how to navigate to next view.
eg. **`func** navigateToDetailsScreen(dataStore: EventsOverviewDataStore?)`

**DataModel :**

Abstractions responsible for getting the  required data as a dependency from the app. 

- EventsOverviewDataModel - responsible for showing dynamic api data
- EventsFileContentDataModel - used internally by EventsOverviewDataModel
- EventsOverviewFields - responsible for showing static feilds

1. It has below use case.
- `protocol will act as a abstraction layer [EventsOverviewDataModel] to pass data [Event] to the eventsPackage without need to actual movement of actual implementation type [Event]to the package.`
- we can send only required fields i need for my events overview page and avoid rest of fields coming from api.

Eg. from service layer I get response as`[Event]`then from provider I am just returning this abstraction [EventsOverviewDataModel].`func fetchScheduledEvents(type: EventsDataFetchType) -> AnyPublisher<[EventsOverviewDataModel], Error>
eg. 
```
public protocol EventsOverviewLogic {
    var title: String { get }
    var heroImageThumbnail: EventsFileContentLogic? { get }
    var eventStart: String? { get }
    var eventEnd: String? { get }
    var location: String { get }
    var isSaved: Bool { get }
    var eventId: String { get }
}
```
## Resources:
all static images required by eventsView.
- saved icon black
- saved icon white
- saced icon

## Scenes:

Contains a list of SwiftUI Scenes

- EventsOverview
<img width="443" alt="Screenshot 2022-06-13 at 16 11 05" src="https://user-images.githubusercontent.com/90820325/173336752-0b407df1-9ff1-426b-bd13-6cdbe36555dc.png">
- EventsDetails [yet to be implemented]
- SavedEvents [yet to be implemented]

**Note**: scenes are implemented as per [Architecture](https://www.notion.so/Swift-UI-UILayer-Architecture-changes-5bcc11c074e0483e8ea5e0a088339002) 

## SwiftUI Application support for EventsPackage:

- create a Router confirming to **EventsRoutingLogic  dependency** which shall be handling navigations requests from events package as per [description](https://www.notion.so/Amway-Events-Package-4c95610e3aec440ea18c6d7fdfbfa513):
- create a Provider confirming to **EventsDataProviderLogic  dependency** which shall be handling operations and data passing requests to events package from app as per [description](https://www.notion.so/Amway-Events-Package-4c95610e3aec440ea18c6d7fdfbfa513):
- create a builder class as below eg. **EventsOverviewBuilder**
- import the events package to the builder.
- using **AmwayGateway** , pass the dependencies and  get the SwiftUIView [eg. EventsOverviewView] from the package.
- pass the appropriate theme . eg. Taiwan
- Use  `EventsOverviewBuilder`  whereever needed in your app. eg. 
**EventsOverviewBuilder().build()**
```
import Events
import SwiftUI

protocol EventsOverviewBuilder {
    func build() -> View
}

struct EventsOverviewBuilder: EventsOverviewSceneBuilder {

    func build() -> some View {
        let router = EventsRouter() // EventsRouter confirm to EventsRoutingLogic
                // pass the dependencies to this provider if needed
        let provider = EventsProvider() // EventsProvider confirming to EventsDataProviderLogic
        return AmwayGateway.makeEventsOverview(theme: .taiwan,
                                          provider: provider,
                                          router: router)
    }
}
```

Sample SwiftUI Project with eventsPackage:
[TestEventsPackage.zip](https://github.com/AmwayACS/creators-ios/files/8890389/TestEventsPackage.zip)




## UIKit Application support for EventsPackage:

if we need to import this to UIKit application. please preform below steps in your app.

- create a hosting view controller and pass root view as **EventsOverviewView**  after importing from events package eg. `EventsOverviewViewController<EventsOverviewView>`
- create a Router confirming to **EventsRoutingLogic  dependency** which shall be handling navigations requests from events package as per [description](https://www.notion.so/Events-Package-SwiftUI-4c95610e3aec440ea18c6d7fdfbfa513):
- create a Provider confirming to **EventsDataProviderLogic  dependency** which shall be handling operations and data passing requests to events package from app as per [description](https://www.notion.so/Events-Package-SwiftUI-4c95610e3aec440ea18c6d7fdfbfa513):
- create a builder class as below eg. **EventsOverviewBuilder**
- import the events package to the builder.
- using **AmwayGateway** , pass the dependencies and  get the SwiftUIView [eg. EventsOverviewView] from the package. 
- pass the appropriate theme . eg. Taiwan
- Use  `EventsOverviewBuilder` to load `EventsOverviewViewController`  whereever needed in your app. eg. 
**EventsOverviewBuilder().build()**

```swift
import Events
import SwiftUI

protocol EventsOverviewSceneBuilder {
    func build() -> UIViewController
}

struct EventsOverviewBuilder: EventsOverviewSceneBuilder {
    // Add dependencies here

    func build() -> UIViewController {
        // Inject dependencies into the interactor and create it.
        let router = EventsOverviewRouter()
        let eventsOverview = makeEventsOverview(router: router)

        let viewController = EventsOverviewController(rootView: eventsOverview)
        router.setViewController(viewController: viewController)
        return viewController
    }
}

// MARK: Events Package Dependency

private extension EventsOverviewBuilder {
    func makeEventsOverview(router: EventsRoutingLogic) -> EventsOverviewView {
        // pass the dependencies to this provider if needed
        let provider = EventsProvider() // EventsProvider confirming to **EventsDataProviderLogic**
        return AmwayGateway.makeEventsOverview(provider: provider,
                                          router: router)
    }
}
```

Sample UIKit Project:
[CreatorsApp](https://github.com/AmwayACS/creators-ios)

## References:

[Swift Package Proposal](https://www.notion.so/Swift-Package-Proposal-2c98c84b75d1443bb5a19c5b3941fc31)
