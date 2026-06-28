import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touch/features/home/presentation/cubit/home_cubit.dart';
import 'package:touch/features/home/presentation/cubit/home_state.dart';
import 'package:touch/generated/locale_keys.g.dart';

/// Home page - main UI for home feature
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Fetch home data when page loads
    context.read<HomeCubit>().getHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.home_title.tr())),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoadedState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.home.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.home.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (state is HomeErrorState) {
            return Center(
              child: Text(
                '${LocaleKeys.error.tr()}: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return Center(child: Text(LocaleKeys.no_data.tr()));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeCubit>().getHome();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
