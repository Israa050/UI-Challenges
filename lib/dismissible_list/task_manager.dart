import 'package:flutter/material.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Complete Flutter Assignment', 'checked': false},
    {'title': 'Review Clean Architecture', 'checked': false},
    {'title': 'Practice Widget Catalog', 'checked': false},
  ];

  final List<Map<String, dynamic>> _removedTasks = [];

  void _reorderTasks(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) newIndex--;
      final task = _tasks.removeAt(oldIndex);
      _tasks.insert(newIndex, task);
    });
  }

  void _toggleTaskCompletion(int index, bool? isChecked) {
    setState(() {
      _tasks[index]['checked'] = isChecked ?? false;
    });
  }

  Future<bool?> _confirmDelete(BuildContext context, int index) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${_tasks[index]['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _removeTask(BuildContext context, int index) {
    final removedTask = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedTask['title']} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _tasks.insert(index, removedTask);
            });
          },
        ),
      ),
    );
  }

  Widget _buildTaskTile(int index) {
    final task = _tasks[index];
    return Container(
      key: ValueKey(index),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle),
        ),
        title: Text(
          task['title'],
          style: TextStyle(
            decoration: task['checked'] ? TextDecoration.lineThrough : null,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Checkbox(
          value: task['checked'],
          onChanged: (value) => _toggleTaskCompletion(index, value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        itemCount: _tasks.length,
        onReorder: _reorderTasks,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_tasks[index]),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12.0),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: _buildTaskTile(index),
            confirmDismiss: (direction) => _confirmDelete(context, index),
            onDismissed: (direction) => _removeTask(context, index),
          );
        },
      ),
    );
  }
}
