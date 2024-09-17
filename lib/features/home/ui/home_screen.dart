import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/features/home/blocs/general_bloc.dart';
import 'package:flutter_application/features/home/blocs/general_events.dart';
import 'package:flutter_application/features/home/blocs/general_statas.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GeneralBloc>().add(LoadGeneralEvent(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1C1C1E),
      body: BlocBuilder<GeneralBloc, GeneralState>(
        builder: (context, state) {
          if (state is GeneralLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GeneralErrorState) {
            print(state.message);
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is GeneralLoadedState) {
            final generalData = state.general;
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Overview',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.grey[800],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Salary',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${generalData.totalSalary}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Expenses:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    for (var expanse in generalData.expanseList)
                      Text(
                        '- ${expanse.name}: ${expanse.amount}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Income:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    for (var income in generalData.incomeList)
                      Text(
                        '- ${income.name}: ${income.amount}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: Text(
              'No Data Available',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
