import 'package:flutter/material.dart';
import 'package:flutter_filip/view/home_player.dart';
import 'package:flutter_filip/view/home_top_box.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(
        '用户名',
      ),
      accountEmail: Text(
        '邮箱',
      ),
      currentAccountPicture: const CircleAvatar(
        child: FlutterLogo(size: 42.0),
      ),
    );
    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          title: Text(
            '页面1',
          ),
          leading: const Icon(Icons.favorite),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(
            '页面2',
          ),
          leading: const Icon(Icons.comment),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '标题',
        ),
      ),
      body: Semantics(
        container: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              HomeIntroBox(),
              // 使用 spacer 进行占位，贴紧页面底部
              Spacer(),
              AddRemoveSongButtons(),
              AudioProgressBar(),
              AudioControlButtons(),
            ]),
          ),
        ),
      ),
      drawer: Drawer(
        child: drawerItems,
      ),
    );
  }
}
