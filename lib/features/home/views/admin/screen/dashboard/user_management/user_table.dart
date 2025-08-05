import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/features/home/views/admin/provider/user_provider.dart';
import 'package:read_quest/core/model/member_model.dart';

class UsersTableScreen extends ConsumerStatefulWidget {
  const UsersTableScreen({super.key});

  @override
  ConsumerState<UsersTableScreen> createState() => _UsersTableScreenState();
}

class _UsersTableScreenState extends ConsumerState<UsersTableScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final member = ref.watch(allRealtimeAcceptedMemberProvider);

    //
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('Users Table'),
        centerTitle: true,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
      ),
      body: member.when(
        data: (member) => UserTable(member: member),
        error: (error, stackTrace) => ErrorScreen(error: error.toString()),
        loading: () => const LoadingScreen(),
      ),
    );
  }
}

class UserTable extends StatelessWidget {
  const UserTable({required this.member, super.key});
  final List<MemberModel> member;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width / 16),
      child: DataTable2(
        headingRowDecoration: BoxDecoration(color: AppColors.grey),
        border: TableBorder.symmetric(
          outside: BorderSide(width: 1, color: AppColors.grey),
        ),
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        columns: const [
          DataColumn(
            label: Text(
              'ID',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn2(
            label: Text(
              'Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            size: ColumnSize.L,
          ),
          DataColumn(
            label: Text(
              'Email',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Role',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DataColumn(
            label: Text('Actions', style: TextStyle(color: Colors.white)),
          ),
        ],
        rows: List<DataRow>.generate(
          member.length,
          (index) => DataRow(
            cells: [
              DataCell(Text(member[index].user.uid)),
              DataCell(Text(member[index].user.name)),
              DataCell(Text(member[index].user.email)),
              DataCell(Text(member[index].role.name)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.amber),
                      onPressed: () {
                        // Handle edit action
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Handle delete action
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({required this.error, super.key});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}
