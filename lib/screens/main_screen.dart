import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/habit.dart';
import '../bloc/habit_bloc.dart';
import '../widgets/habit_item.dart';
import '../widgets/add_edit_habit_modal.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF836DFF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDateAndAddButton(context),
            const SizedBox(height: 16),
            _buildHabitsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Мои привычки',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDateAndAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Чт, 5 мая',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => _showAddEditHabitModal(context),
            child: const Text(
              'Добавить задачу',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: BlocBuilder<HabitBloc, List<Habit>>(
          builder: (context, habits) {
            final incompleteHabits =
                habits.where((h) => h.current < h.target).toList();
            final completeHabits =
                habits.where((h) => h.current >= h.target).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHabitSection(
                    title: 'Ожидает выполнения:',
                    habits: incompleteHabits,
                    isComplete: false,
                    context: context,
                  ),
                  _buildHabitSection(
                    title: 'Выполнено:',
                    habits: completeHabits,
                    isComplete: true,
                    context: context,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHabitSection({
    required String title,
    required List<Habit> habits,
    required bool isComplete,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (habits.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Нет привычек'),
          ),
        ...habits.map(
          (habit) => Dismissible(
            key: Key(habit.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              context.read<HabitBloc>().deleteHabit(habit.id);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: HabitItem(habit: habit, isComplete: isComplete),
          ),
        ),
      ],
    );
  }

  void _showAddEditHabitModal(BuildContext context, {Habit? habit}) {
    final titleController = TextEditingController(text: habit?.title ?? '');
    final targetController = TextEditingController(
      text: habit?.target.toString() ?? '',
    );

    final habitBloc = context.read<HabitBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => BlocProvider.value(
            value: habitBloc,
            child: AddEditHabitModal(
              habit: habit,
              titleController: titleController,
              targetController: targetController,
            ),
          ),
    );
  }
}
