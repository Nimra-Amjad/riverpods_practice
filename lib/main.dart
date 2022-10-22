import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

abstract class WebsocketClient {
  Stream<int> getCounterStream();
}

// class FakeWebsocketClient implements WebsocketClient {
//   @override
//   Stream<int> getCounterStream() async* {
//     int i = 0;
//     while (true) {
//       await Future.delayed(const Duration(milliseconds: 500));
//       yield i++;
//     }
//   }
// }

// final websocketClientProvider = Provider<WebsocketClient>((ref) {
//   return FakeWebsocketClient();
// });

final counterProvider = StateProvider((ref) => 0);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Counter App",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: ((context) => const CounterPage())));
          },
          child: const Text("Go to Counter Page"),
        ),
      ),
    );
  }
}

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int counter = ref.watch(counterProvider);
    ref.listen<int>(counterProvider, (previous, next) {
      if (next == 5) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Warning"),
                content: const Text(
                    'Counter dangerously high.Consider resetting it.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ],
              );
            });
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(counterProvider);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Center(
        child: Text(
          counter.toString(),
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.notifier).state++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
