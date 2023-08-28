import 'package:example/data.dart';
import 'package:flutter/material.dart';
import 'package:loadmore_data/loadmore_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Load More Pagination"),
      ),
      body: LoadMoreListData(
        onInit: () async {
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
          final data = await nextCharacters(index);
          return data.results!;
        },
        itemPadding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        topWidget: const Text("Pagination Start From Here"),
        builder: (context, itemData) {
          return Container(
            decoration:
            BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                Flexible(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.network(
                      itemData.image!,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: Column(
                    children: [
                      Text(itemData.name ?? ''),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(itemData.status ?? ''),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(itemData.species ?? '')
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

