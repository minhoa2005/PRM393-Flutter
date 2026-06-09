import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes/app_router.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {
        "name": "Nguyễn Văn An",
        "username": "nguyenvanan",
        "email": "nguyenvanan@gmail.com",
      },
      {
        "name": "Trần Thị Bình",
        "username": "tranthibinh",
        "email": "tranthibinh@gmail.com",
      },
      {
        "name": "Lê Minh Đức",
        "username": "leminhduc",
        "email": "leminhduc@gmail.com",
      },
      {
        "name": "Phạm Ngọc Anh",
        "username": "phamngocanh",
        "email": "phamngocanh@gmail.com",
      },
      {
        "name": "Hoàng Quốc Việt",
        "username": "hoangquocviet",
        "email": "hoangquocviet@gmail.com",
      },
      {
        "name": "Đặng Thị Hương",
        "username": "dangthihuong",
        "email": "dangthihuong@gmail.com",
      },
      {
        "name": "Vũ Thanh Tùng",
        "username": "vuthanhtung",
        "email": "vuthanhtung@gmail.com",
      },
      {
        "name": "Bùi Khánh Linh",
        "username": "buikhanhlinh",
        "email": "buikhanhlinh@gmail.com",
      },
      {
        "name": "Đỗ Thành Công",
        "username": "dothanhcong",
        "email": "dothanhcong@gmail.com",
      },
      {
        "name": "Phan Thu Trang",
        "username": "phanthutrang",
        "email": "phanthutrang@gmail.com",
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        actions: [
          IconButton(icon: const Icon(Icons.replay_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Tìm kiếm người dùng',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: () {}, child: const Icon(Icons.sort)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=${index + 1}',
                      ),
                    ),
                    title: Text(user['name']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(user['username']!), Text(user['email']!)],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRouter.addUser,
                              arguments: user,
                            );
                          },
                          padding: EdgeInsets.zero,
                          iconSize: 15,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          iconSize: 15,
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye_sharp),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRouter.userDetail,
                              arguments: user,
                            );
                          },
                          padding: EdgeInsets.zero,
                          iconSize: 15,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.addUser);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
