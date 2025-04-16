import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdek_plagin/CdekApi.dart';
import 'package:sdek_plagin/UserOrderInfo.dart';

import 'CdekAuth.dart';

class ConfirmationOrderScreen extends StatefulWidget {
  const ConfirmationOrderScreen({super.key});

  @override
  State<ConfirmationOrderScreen> createState() => _ConfirmationOrderState();
}

class _ConfirmationOrderState extends State<ConfirmationOrderScreen> {
  late Future<double?> _deliveryCostFuture;
  static const clientId = 'NYnDZhNexvHneGnk29cdGpZuAxwFot6J';
  static const clientSecret = 'RglJK9tAYIUUhP2Dt3NuBChjm7iESwkf';

  @override
  void initState() {
    super.initState();
    _deliveryCostFuture = CdekApi(CdekAuth(clientId: clientId, clientSecret: clientSecret)).calculateDeliveryCost(UserOrderInfo.instance.pointData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подтверждение заказа')),
      body: FutureBuilder<double?>(
        future: _deliveryCostFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Ошибка при расчете стоимости доставки'));
          }

          final deliveryCost = snapshot.data!;
          final totalCost = 2500 + 2 * 600 + deliveryCost;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const _SectionTitle('ДАННЫЕ ПОЛУЧАТЕЛЯ'),
                Text(UserOrderInfo.instance.fullName,style: TextStyle(fontSize: 15),),
                Text(UserOrderInfo.instance.email,style: TextStyle(fontSize: 15),),
                Text(UserOrderInfo.instance.phoneNumber,style: TextStyle(fontSize: 15),),
                const SizedBox(height: 16),

                const _SectionTitle('ПУНКТ ВЫДАЧИ'),
                Text(UserOrderInfo.instance.pointData.description,style: TextStyle(fontSize: 15),),
                Text(UserOrderInfo.instance.pointData.workTime,style: TextStyle(fontSize: 15),),
                const SizedBox(height: 16),

                const _SectionTitle('ТОВАРЫ'),
                const _ProductItem(title: 'Рюкзак', quantity: 1, price: 2500),
                const _ProductItem(title: 'Блокнот', quantity: 2, price: 600),
                const SizedBox(height: 16),

                const _SectionTitle('СТОИМОСТЬ ДОСТАВКИ'),

                Text('→ Самовывоз из ПВЗ: ${deliveryCost.toStringAsFixed(0)} ₽',style: TextStyle(fontSize: 15),),
                const SizedBox(height: 16),

                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ИТОГО:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      '${totalCost.toStringAsFixed(0)} ₽',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Center(
                  child: GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                        color: Colors.green,
                      ),
                      width: 200,
                      height: 50,
                      child: const Center(
                        child: Text(
                          'Оформить заказ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  Shader createGradient(Rect bounds) {
    return LinearGradient(
      colors: [Colors.blue, Colors.green],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => createGradient(bounds),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
    // return Text(
    //   text,
    //   style:
    //   const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 2),
    // );
  }
}

class _ProductItem extends StatelessWidget {
  final String title;
  final int quantity;
  final int price;

  const _ProductItem({
    required this.title,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final total = quantity * price;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$quantity× $title'),
          Text('$total ₽'),
        ],
      ),
    );
  }
}