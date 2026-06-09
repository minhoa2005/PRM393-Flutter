import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({super.key, this.data});
  final Map<String, String>? data;

  @override
  Widget build(BuildContext context) {
    final user =
        data ??
        {
          "name": "Nguyễn Văn An",
          "username": "nguyenvanan",
          "email": "nguyenvanan@example.com",
          "phone": "0965 123 456",
          "age": "28",
          "gender": "Nam",
          "birthday": "15/05/1996",
          "address":
              "123 Đường Lê Lợi, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh",
        };

    final String name = user['name'] ?? 'Nguyễn Văn An';
    final String username = user['username'] ?? 'nguyenvanan';
    final String email = user['email'] ?? 'nguyenvanan@example.com';
    final String phone = user['phone'] ?? '0965 123 456';
    final String age = user['age'] ?? '28';
    final String gender = user['gender'] ?? 'Nam';
    final String birthday = user['birthday'] ?? '15/05/1996';
    final String address =
        user['address'] ??
        '123 Đường Lê Lợi, Phường Bến Nghé, Quận 1, TP. Hồ Chí Minh';

    final usersList = [
      "Nguyễn Văn An",
      "Trần Thị Bình",
      "Lê Minh Đức",
      "Phạm Ngọc Anh",
      "Hoàng Quốc Việt",
      "Đặng Thị Hương",
      "Vũ Thanh Tùng",
      "Bùi Khánh Linh",
      "Đỗ Thành Công",
      "Phan Thu Trang",
    ];
    int userIndex = usersList.indexOf(name);
    int avatarIndex = userIndex != -1 ? userIndex + 1 : 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chi tiết người dùng',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=$avatarIndex',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@$username',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detail Information List
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildDetailRow(
                    icon: Icons.mail_outline,
                    label: 'Email',
                    value: email,
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    icon: Icons.phone_outlined,
                    label: 'Số điện thoại',
                    value: phone,
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    icon: Icons.person_outline,
                    label: 'Tuổi',
                    value: age,
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    icon: Icons.wc_outlined,
                    label: 'Giới tính',
                    value: gender,
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    icon: Icons.cake_outlined,
                    label: 'Ngày sinh',
                    value: birthday,
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    icon: Icons.location_on_outlined,
                    label: 'Địa chỉ',
                    value: address,
                    isMultiline: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bottom Actions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Navigate to edit user screen
                        Navigator.pushNamed(
                          context,
                          '/home/user-management/add',
                          arguments: user,
                        );
                      },
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      label: const Text(
                        'Chỉnh sửa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        side: BorderSide(color: Colors.blue[700]!, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Implement delete confirmation dialog or callback in future
                      },
                      icon: const Icon(Icons.delete_outline, size: 20),
                      label: const Text(
                        'Xóa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[600],
                        side: BorderSide(color: Colors.red[600]!, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: isMultiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[600], size: 22),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          if (!isMultiline)
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 0.5, color: Colors.grey[200]);
  }
}
