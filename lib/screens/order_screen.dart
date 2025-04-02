import 'package:dancemate_app/provider/dancer_provider.dart';
import 'package:dancemate_app/provider/order_provider.dart';
import 'package:dancemate_app/provider/reserve_provider.dart';
import 'package:dancemate_app/screens/order_complete_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderScreen extends ConsumerWidget {
  final int courseDetailId;
  final int dancerId;

  const OrderScreen({
    super.key,
    required this.courseDetailId,
    required this.dancerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketData = ref.watch(getDancerDetailTicketProvider(dancerId));
    int selectUserTicket = ref.watch(selectUserTicketProvider);
    int selectedTicketPrice = ref.watch(selectedTicketPriceProvider);
    bool selectedEasyPrice = ref.watch(selectedEasyPaymentProvider);
    bool selectedCardPrice = ref.watch(selectedCardPaymentProvider);
    bool selectedDepositPrice = ref.watch(selectedDepositPaymentProvider);
    int selectEasyPay = ref.watch(selectedEasyNaverKakaoPaymentProvider);
    DateTime now = DateTime.now().add(const Duration(days: 30));
    String expiredDate = DateFormat('yyyy-MM-dd').format(now);
    NumberFormat format = NumberFormat('###,###,###,###');

    if (ticketData.value != null) {
      if (selectUserTicket == 0) {
        if (ticketData.value['tickets'].length > 0) {
          selectUserTicket = ticketData.value['tickets'][0]['id'];
          selectedTicketPrice = ticketData.value['tickets'][0]['price'];
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('결제하기'),
      ),
      body: SingleChildScrollView(
        child: ticketData.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) {
            print(error);
            return SizedBox(
              width: 300,
              child: Text('error: $error'),
            );
          },
          data: (dataList) {
            final dancerData = dataList['dancer'];
            final dancerNickname = dancerData['nickname'];

            final ticketDetailData = dataList['tickets'];
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '티켓',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: ticketDetailData.length,
                    itemBuilder: (context, index) {
                      final ticketDetail = ticketDetailData[index];

                      final ticketId = ticketDetail['id'];
                      final ticketCount = ticketDetail['count'];
                      final ticketCost = ticketDetail['cost'];
                      final ticketPrice = ticketDetail['price'];

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: ticketId,
                                groupValue: selectUserTicket,
                                onChanged: (value) {
                                  ref
                                      .read(selectUserTicketProvider.notifier)
                                      .update((state) => value as int);

                                  ref
                                      .read(
                                          selectedTicketPriceProvider.notifier)
                                      .update((state) => ticketPrice as int);
                                },
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff6555FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    dancerNickname,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$ticketCount회권',
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          Text('$expiredDate까지 '),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          '결제수단',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(selectedEasyPaymentProvider.notifier)
                                    .update((state) => true);

                                ref
                                    .read(selectedCardPaymentProvider.notifier)
                                    .update((state) => false);

                                ref
                                    .read(
                                        selectedDepositPaymentProvider.notifier)
                                    .update((state) => false);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedEasyPrice
                                      ? const Color(0xFFA48AFF)
                                      : Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFA48AFF),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 25,
                                  ),
                                  child: Text(
                                    '간편결제',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: selectedEasyPrice
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(selectedCardPaymentProvider.notifier)
                                    .update((state) => true);

                                ref
                                    .read(selectedEasyPaymentProvider.notifier)
                                    .update((state) => false);

                                ref
                                    .read(
                                        selectedDepositPaymentProvider.notifier)
                                    .update((state) => false);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedCardPrice
                                      ? const Color(0xFFA48AFF)
                                      : Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFA48AFF),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 30,
                                  ),
                                  child: Text(
                                    '카드결제',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: selectedCardPrice
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(
                                        selectedDepositPaymentProvider.notifier)
                                    .update((state) => true);

                                ref
                                    .read(selectedEasyPaymentProvider.notifier)
                                    .update((state) => false);

                                ref
                                    .read(selectedCardPaymentProvider.notifier)
                                    .update((state) => false);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedDepositPrice
                                      ? const Color(0xFFA48AFF)
                                      : Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFA48AFF),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 30,
                                  ),
                                  child: Text(
                                    '무통장입금',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: selectedDepositPrice
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (selectedEasyPrice)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 0,
                                    groupValue: selectEasyPay,
                                    onChanged: (value) {
                                      ref
                                          .read(
                                              selectedEasyNaverKakaoPaymentProvider
                                                  .notifier)
                                          .update((state) => value as int);
                                    },
                                  ),
                                  const Text(
                                    '네이버페이',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 1,
                                    groupValue: selectEasyPay,
                                    onChanged: (value) {
                                      ref
                                          .read(
                                              selectedEasyNaverKakaoPaymentProvider
                                                  .notifier)
                                          .update((state) => value as int);
                                    },
                                  ),
                                  const Text(
                                    '카카오페이',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '총 결제금액',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${format.format(selectedTicketPrice)}원',
                            style: const TextStyle(
                              color: Color(0xff3F51B5),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Text('결제할 때 주의사항이나 동의사항 등등'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
            onPressed: () async {
              final result =
                  await ref.watch(postPaymentProvider(selectUserTicket).future);
              if (result['result_code'] == 200) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderCompleteScreen(
                      courseDetailId: courseDetailId,
                      paymentData: result['result_data'],
                    ),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFA48AFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '결제하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
