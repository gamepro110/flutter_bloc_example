import 'package:bloc_testground/constants/enums.dart';
import 'package:bloc_testground/logic/cubit/counter_cubit.dart';
import 'package:bloc_testground/logic/cubit/internet_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetConnected &&
            state.connectionType == ConnectionType.wifi) {
          BlocProvider.of<CounterCubit>(context).increment();
        } else if (state is InternetConnected &&
            state.connectionType == ConnectionType.mobile) {
          BlocProvider.of<CounterCubit>(context).decrement();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed('/settings');
                },
                title: const Text('Settings'),
              )
            ],
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              BlocBuilder<InternetCubit, InternetState>(
                  builder: (context, state) {
                if (state is InternetConnected &&
                    state.connectionType == ConnectionType.wifi) {
                  return const Text(
                    'Wifi',
                  );
                } else if (state is InternetConnected &&
                    state.connectionType == ConnectionType.mobile) {
                  return const Text(
                    'Mobile',
                  );
                } else if (state is InternetConnected &&
                    state.connectionType == ConnectionType.ethernet) {
                  return const Text(
                    'Ethernet',
                  );
                } else if (state is InternetDisconnected) {
                  return const Text(
                    'Disconnected',
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'You have pushed the button this many times:',
              ),
              BlocConsumer<CounterCubit, CounterState>(
                listener: (context, state) {
                  const Duration duration = Duration(milliseconds: 300);
                  switch (state.wasIncremented) {
                    case true:
                      {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Incremented"),
                          duration: duration,
                        ));
                        break;
                      }
                    case false:
                      {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Decremented"),
                          duration: duration,
                        ));
                        break;
                      }
                    default:
                      {
                        break;
                      }
                  }
                },
                builder: (context, state) {
                  return Text(
                    '${state.counterValue}',
                    style: Theme.of(context).textTheme.headline4,
                  );
                },
              ),
              const SizedBox(
                height: 3,
              ),
              /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () =>
                          BlocProvider.of<CounterCubit>(context).increment(),
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 15),
                    FloatingActionButton(
                      onPressed: () =>
                          BlocProvider.of<CounterCubit>(context).decrement(),
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ) */
            ],
          ),
        ),
      ),
    );
  }
}
