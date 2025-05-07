import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/habit.dart';
import '../bloc/habit_bloc.dart';

class HabitItem extends StatelessWidget {
  final Habit habit;
  final bool isComplete;

  const HabitItem({super.key, required this.habit, required this.isComplete});

  @override
  Widget build(BuildContext context) {
    final habitBloc = BlocProvider.of<HabitBloc>(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  habit.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 24),
                      color: Colors.grey,
                      onPressed: () => habitBloc.decrementProgress(habit.id),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isComplete
                            ? Icons.check
                            : habit.target == 1
                            ? Icons.check_circle_outline
                            : Icons.add,
                        size: 24,
                      ),
                      color:
                          isComplete ? Colors.green : const Color(0xFF00C2CB),
                      onPressed: () => habitBloc.incrementProgress(habit.id),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${habit.current}/${habit.target}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
