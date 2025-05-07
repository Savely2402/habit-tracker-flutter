import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/habit.dart';
import '../bloc/habit_bloc.dart';

class AddEditHabitModal extends StatelessWidget {
  final Habit? habit;
  final TextEditingController titleController;
  final TextEditingController targetController;

  const AddEditHabitModal({
    super.key,
    this.habit,
    required this.titleController,
    required this.targetController,
  });

  @override
  Widget build(BuildContext context) {
    final habitBloc = BlocProvider.of<HabitBloc>(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              habit == null ? 'Добавить привычку' : 'Редактировать привычку',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Название привычки',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Цель (количество в день)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final target = int.tryParse(targetController.text.trim()) ?? 0;

                if (title.isEmpty || target <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Пожалуйста, заполните все поля корректно'),
                    ),
                  );
                  return;
                }

                if (habit == null) {
                  habitBloc.addHabit(title, target);
                } else {
                  habitBloc.updateHabit(habit!.id, title, target);
                }

                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
