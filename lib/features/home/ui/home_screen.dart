import 'package:flutter/material.dart';
import 'package:flutter_application/features/home/blocs/general_bloc.dart';
import 'package:flutter_application/features/home/blocs/general_events.dart';
import 'package:flutter_application/features/home/blocs/general_statas.dart';
import 'package:flutter_application/features/home/data/models/expanse_model.dart';
import 'package:flutter_application/features/home/data/models/income.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    // Load general data when the screen is initialized
    context.read<GeneralBloc>().add(LoadGeneralEvent(widget.username));
  }

  void _showAddIncomeDialog() {
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Income'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text);
                final reason = _reasonController.text;

                if (amount != null && reason.isNotEmpty) {
                  context.read<GeneralBloc>().add(
                    AddIncomeEvent(
                      username: widget.username,
                      amount: amount,
                      reason: reason,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddExpenseDialog() {
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(_amountController.text);
                final reason = _reasonController.text;

                if (amount != null && reason.isNotEmpty) {
                  context.read<GeneralBloc>().add(
                    AddExpenseEvent(
                      username: widget.username,
                      amount: amount,
                      reason: reason,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1C1C1E),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.grey[900],
      ),
      body: BlocBuilder<GeneralBloc, GeneralState>(
        builder: (context, state) {
          if (state is GeneralLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GeneralErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is GeneralLoadedState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overview',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        CircleAvatar(
                          child: Icon(Icons.person, color: Colors.white),
                          backgroundColor: Colors.grey[800],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: Colors.grey[800],
                      child: ListTile(
                        title: const Text('Total Salary'),
                        subtitle: Text(
                          '\$${state.general.totalSalary.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: _showAddIncomeDialog,
                          child: const Text('Add Income'),
                        ),
                        ElevatedButton(
                          onPressed: _showAddExpenseDialog,
                          child: const Text('Add Expense'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Expenses:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    if (state.general.expanseList.isNotEmpty)
                      for (var expanse in state.general.expanseList)
                        Text(
                          '- ${expanse.name}: \$${expanse.amount.toStringAsFixed(2)}',
                          style:
                              const TextStyle(color: Colors.white, fontSize: 16),
                        )
                    else
                      const Text(
                        'No expenses available',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    const SizedBox(height: 10),
                    const Text(
                      'Income:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    if (state.general.incomeList.isNotEmpty)
                      for (var income in state.general.incomeList)
                        Text(
                          '- ${income.name}: \$${income.amount.toStringAsFixed(2)}',
                          style:
                              const TextStyle(color: Colors.white, fontSize: 16),
                        )
                    else
                      const Text(
                        'No income available',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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
