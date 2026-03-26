import 'package:flutter/material.dart';
import 'package:ksta/pages/home/controllers/homepage_controller.dart';
import 'package:ksta/pages/home/widgets/home_page_list.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  late final HomepageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomepageController()..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          body: HomepageList(
            controller: _controller,
            pageTitle: _controller.pageTitle,
          ),
        );
      },
    );
  }
}
