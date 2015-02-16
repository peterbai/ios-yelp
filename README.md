## Yelp

A Yelp search app using the [Yelp API](http://developer.rottentomatoes.com/docs/read/JSON).

Time spent: `16 hours`

### Features

#### Required

- [x] Search results page
   - [x] Table rows should be dynamic height according to the content height
   - [x] Custom cells should have the proper Auto Layout constraints
   - [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [x] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
   - [x] The filters table should be organized into sections as in the mock.
   - [x] You can use the default UISwitch for on/off states.
   - [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [x] Display some of the available Yelp categories (choose any 3-4 that you want).

#### Optional

- [x] Search results page
   - [x] Infinite scroll for restaurant results
   - [x] Implement map view of restaurant results
- [x] Filter page
   - [x] Radius filter should expand as in the real Yelp app
   - [x] Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.)
   - [x] implement a custom switch
- [x] Implement the restaurant detail page.

### Walkthrough

![Video Walkthrough](./gif/walkthrough-02.gif)

Credits
---------
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager)
* [SVProgressHUD](https://github.com/TransitApp/SVProgressHUD)
* [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh)
* [SevenSwitch](https://github.com/bvogelzang/SevenSwitch)
* [FXBlurView](https://github.com/nicklockwood/FXBlurView)
* [VCTransitionsLibrary](https://github.com/ColinEberhardt/VCTransitionsLibrary)