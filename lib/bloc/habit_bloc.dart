import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/habit.dart';

class HabitBloc extends Cubit<List<Habit>> {
  HabitBloc()
    : super([
        Habit(
          id: '1',
          title: 'Не есть сладкое',
          target: 1,
          current: 0,
          createdAt: DateTime.now(),
        ),
        Habit(
          id: '2',
          title: 'Пить воду 8 раз',
          target: 8,
          current: 0,
          createdAt: DateTime.now(),
        ),
        Habit(
          id: '3',
          title: 'Зарядка утром',
          target: 1,
          current: 1,
          createdAt: DateTime.now(),
        ),
        Habit(
          id: '4',
          title: 'Поесть 4 раза',
          target: 4,
          current: 4,
          createdAt: DateTime.now(),
        ),
      ]);

  void addHabit(String title, int target) {
    final newHabit = Habit(
      id: DateTime.now().toString(),
      title: title,
      target: target,
      createdAt: DateTime.now(),
    );
    emit([...state, newHabit]);
  }

  void updateHabit(String id, String title, int target) {
    emit(
      state.map((habit) {
        if (habit.id == id) {
          return habit.copyWith(title: title, target: target);
        }
        return habit;
      }).toList(),
    );
  }

  void incrementProgress(String id) {
    emit(
      state.map((habit) {
        if (habit.id == id && habit.target != habit.current) {
          return habit.copyWith(current: habit.current + 1);
        }
        return habit;
      }).toList(),
    );
  }

  void decrementProgress(String id) {
    emit(
      state.map((habit) {
        if (habit.id == id && habit.current != 0) {
          return habit.copyWith(current: habit.current - 1);
        }
        return habit;
      }).toList(),
    );
  }

  void deleteHabit(String id) {
    emit(state.where((habit) => habit.id != id).toList());
  }
}
