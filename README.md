# Loadmore Data

[![Pub](https://img.shields.io/pub/v/loadmore_data.svg)](https://pub.dartlang.org/packages/loadmore_data)
[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://opensource.org/licenses/MIT)
[![License](https://img.shields.io/badge/license-MIT-orange.svg)](https://github.com/ionicfirebaseapp/getwidget/blob/master/LICENSE)

loadmore_data is a flutter package that can handel infinity scroll pagination

## Demo

![loadmore_data](https://pub-025eba96160d45eb8b4d209ff55bfdc6.r2.dev/load_more.gif "loadmore_data demo")

## Installation 💻

**❗ In order to start using Loadmore Data you must have the [Flutter SDK][flutter_install_link]
installed on your machine.**

Add `loadmore_data` to your `pubspec.yaml`:

``` yaml
dependencies:
  loadmore_data:
```

Install it:

``` sh
flutter packages get
```

## Example

``` dart
LoadMoreListData(
        onInit: () async {
          // call api for initial data and return list of data
          final data = await initCharacters();
          return data.results!;
        },
        onInitialLoading: const Center(
          child: CircularProgressIndicator(),
        ),
        onLoadMoreLoading: const Center(
          child: CircularProgressIndicator(),
        ),
        onLoad: (index) async {

          // call api for more data and return list of data
          final data = await nextCharacters(index);
          return data.results!;
        },
        itemPadding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        topWidget: const Text("Pagination Start From Here"),
        builder: (context, itemData) {
          // return a widget that represent a single item
        },
      ),
```

## Parameters

| Parameter                         | Definition                                                                                                                                                                                                                                |
|-----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `OnInit<T> onInit`                | [onInit] is a required argument for the [LoadMoreListData] widget. It takes a function that will return [OnInit] . [OnInit] can be `FutureOr<Iterable<T>>` This function will call on `initState` of [LoadMoreListData]'s life cycle      |
| `OnLoad<T> onLoad`                | [onLoad] is a required argument for the [LoadMoreListData] widget.  It takes a function that will return [OnLoad] . [OnLoad] can be `FutureOr<Iterable<T>>`  This function will call when the user reached to the end of the list of data |
| `ItemBuilder<T> builder`          | builder will [BuildContext] and `itemData` as a single item.  and it will expect a widget that will represent a single item                                                                                                               |
| `Widget? onInitialLoading`        | [onInitialLoading] is a widget that will display until the initial data is loaded                                                                                                                                                         |
| `Widget? onLoadMoreLoading`       | [onLoadMoreLoading] is a widget at end of the list that will display when waiting for a response on a pagination API request                                                                                                              |
| `Widget? onNoData`                | [onNoData] is a widget that will have no more data to display                                                                                                                                                                             |
| `Widget? topWidget`               | you can pass an additional widget that will display on top of the list                                                                                                                                                                    |
| `Widget? bottomWidget`            | you can pass an additional widget that will display on the bottom of the list                                                                                                                                                             |
| `int? initPage`                   | [initPage] will take a [int] value representing the initial circle of requests. by default its is  `1`                                                                                                                                    |
| `EdgeInsetsGeometry? padding`     | padding for [LoadMoreListData] widget                                                                                                                                                                                                     |
| `EdgeInsetsGeometry? itemPadding` | padding for [LoadMoreListData] widget's items                                                                                                                                                                                             |
