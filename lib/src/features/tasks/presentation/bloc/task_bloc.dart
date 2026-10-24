import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/toggle_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';

import 'task_event.dart';
import 'task_state.dart';

@injectable
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTask _createTask;
  final GetTasks _getTasks;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final ToggleTask _toggleTask;

  StreamSubscription<List<TaskEntity>>? _subscription;

  TaskBloc(
    this._createTask,
    this._getTasks,
    this._updateTask,
    this._deleteTask,
    this._toggleTask,
  ) : super(const TaskState()) {
    on<TaskStarted>(_onStarted);
    on<TaskStopped>(_onStopped);
    on<TaskItemsUpdated>(_onItemsUpdated);
    on<TaskSubscriptionFailed>(_onSubscriptionFailed);

    on<TaskCreateRequested>(_onCreate);
    on<TaskUpdateRequested>(_onUpdate);
    on<TaskToggleRequested>(_onToggle);
    on<TaskDeleteRequested>(_onDelete);
    on<TaskActionCleared>(_onActionCleared);
  }

  // ==================== WATCH TASKS ====================

  Future<void> _onStarted(TaskStarted event, Emitter<TaskState> emit) async {
    await _subscription?.cancel();
    _subscription = null;

    emit(
      state.copyWith(
        status: TaskStatusView.loading,
        tasks: const [],
        action: TaskAction.none,
        actionStatus: TaskActionStatus.initial,
        clearMessages: true,
      ),
    );

    try {
      _subscription = _getTasks().listen(
        (tasks) {
          if (!isClosed) {
            add(TaskItemsUpdated(tasks));
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          debugPrint('❌ Firestore Stream Error: $error');
          debugPrintStack(stackTrace: stackTrace);

          if (!isClosed) {
            add(TaskSubscriptionFailed(error.toString()));
          }
        },
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: TaskStatusView.failure,
          errorMessage: 'Không thể kết nối Firestore.',
          clearMessages: true,
        ),
      );
    }
  }

  Future<void> _onStopped(TaskStopped event, Emitter<TaskState> emit) async {
    await _subscription?.cancel();
    _subscription = null;

    emit(const TaskState());
  }

  void _onItemsUpdated(TaskItemsUpdated event, Emitter<TaskState> emit) {
    emit(state.copyWith(status: TaskStatusView.success, tasks: event.tasks));
  }

  void _onSubscriptionFailed(
    TaskSubscriptionFailed event,
    Emitter<TaskState> emit,
  ) {
    emit(
      state.copyWith(
        status: TaskStatusView.failure,
        errorMessage: event.message,
        clearMessages: true,
      ),
    );
  }

  // ==================== CREATE TASK ====================

  Future<void> _onCreate(
    TaskCreateRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        action: TaskAction.create,
        actionStatus: TaskActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      await _createTask(event.task);

      emit(
        state.copyWith(
          action: TaskAction.create,
          actionStatus: TaskActionStatus.success,
          successMessage: 'Tạo công việc thành công',
          clearMessages: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          action: TaskAction.create,
          actionStatus: TaskActionStatus.failure,
          errorMessage: 'Không thể tạo công việc.',
          clearMessages: true,
        ),
      );
    }
  }

  // ==================== UPDATE TASK ====================

  Future<void> _onUpdate(
    TaskUpdateRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        action: TaskAction.update,
        actionStatus: TaskActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      await _updateTask(event.task);

      emit(
        state.copyWith(
          action: TaskAction.update,
          actionStatus: TaskActionStatus.success,
          successMessage: 'Cập nhật công việc thành công',
          clearMessages: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          action: TaskAction.update,
          actionStatus: TaskActionStatus.failure,
          errorMessage: 'Không thể cập nhật công việc.',
          clearMessages: true,
        ),
      );
    }
  }

  // ==================== COMPLETE TASK ====================

  Future<void> _onToggle(
    TaskToggleRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        action: TaskAction.toggle,
        actionStatus: TaskActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      await _toggleTask(taskId: event.taskId, isCompleted: event.isCompleted);

      emit(
        state.copyWith(
          action: TaskAction.toggle,
          actionStatus: TaskActionStatus.success,
          successMessage: 'Đã cập nhật trạng thái công việc',
          clearMessages: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          action: TaskAction.toggle,
          actionStatus: TaskActionStatus.failure,
          errorMessage: 'Không thể đổi trạng thái công việc.',
          clearMessages: true,
        ),
      );
    }
  }

  // ==================== DELETE TASK ====================

  Future<void> _onDelete(
    TaskDeleteRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(
      state.copyWith(
        action: TaskAction.delete,
        actionStatus: TaskActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      await _deleteTask(event.taskId);

      emit(
        state.copyWith(
          action: TaskAction.delete,
          actionStatus: TaskActionStatus.success,
          successMessage: 'Xóa công việc thành công',
          clearMessages: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          action: TaskAction.delete,
          actionStatus: TaskActionStatus.failure,
          errorMessage: 'Không thể xóa công việc.',
          clearMessages: true,
        ),
      );
    }
  }

  // ==================== CLEAR ACTION ====================

void _onActionCleared(
  TaskActionCleared event,
  Emitter<TaskState> emit,
) {
  if (state.actionStatus == TaskActionStatus.loading) {
    return;
  }

  emit(
    state.copyWith(
      action: TaskAction.none,
      actionStatus: TaskActionStatus.initial,
      clearMessages: true,
    ),
  );
}
  // ==================== DISPOSE ====================

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
