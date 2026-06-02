import 'package:demo1/core/constrants/app_colors.dart';
import 'package:demo1/presentation/pages/add_user_page.dart';
import 'package:flutter/material.dart';

class ManageUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý người dùng'),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm người dùng',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddUserPage()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Thêm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryBlue,
                            child: Text(
                              'A',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            'Nguyen Van A',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('nguyenvana@example.com'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.edit,
                        color: AppColors.textGrey,
                        size: 20,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryBlue,
                            child: Text(
                              'B',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            'Trần Thị B',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('tranthib@example.com'),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.edit,
                        color: AppColors.textGrey,
                        size: 20,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
