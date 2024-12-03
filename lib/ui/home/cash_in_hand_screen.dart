import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';

class CashInHandScreen extends StatefulWidget {
  const CashInHandScreen({super.key});

  @override
  State<CashInHandScreen> createState() => _CashInHandScreenState();
}

class _CashInHandScreenState extends State<CashInHandScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  Scaffold(backgroundColor: AppColors.textOnPrimary,
    appBar: DefaultAppBar(title: 'Cash In Hand', size: size),
    body: Container(),);
  }
}
