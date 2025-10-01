import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fam_assignment/view/contextual_feed.dart';
import 'package:fam_assignment/view_model/feed_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final feedVM = Provider.of<FeedViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FamPay'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const ContextualFeed(),
    );
  }
}
