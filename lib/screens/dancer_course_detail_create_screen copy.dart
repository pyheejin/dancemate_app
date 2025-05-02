import 'package:dancemate_app/provider/dancer_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class DancerCourseDetailCreateScreen extends ConsumerWidget {
  const DancerCourseDetailCreateScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    var newDetailList = ref.watch(dancerCourseProvider);

    void onAddTap(Map<String, dynamic> detail) {
      // final result =
      //     ref.read(dancerCourseProvider.notifier).addCourseDetail(detail);
      // newDetailList = result;
      // print(newDetailList);
    }

    void onRemoveTap(Map<String, dynamic> detail) {
      ref.read(dancerCourseProvider.notifier).removeCourseDetail(detail);
    }

    void onSaveTap(int courseDetailId, int dancerId) {}

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 30,
                            ),
                            child: Text(
                              '제목',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                ),
                                suffixIcon: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: newDetailList.length + 1,
                      itemBuilder: (context, index) {
                        DateTime now = DateTime.now();
                        TimeOfDay initialTime = TimeOfDay.now();
                        String initialHour =
                            initialTime.hour.toString().padLeft(2, '0');
                        String initialMinute =
                            initialTime.minute.toString().padLeft(2, '0');
                        CalendarFormat calendarFormat = CalendarFormat.month;
                        DateTime selectDay = ref.watch(selectDateProvider);
                        List<String> days = [
                          '_',
                          '월',
                          '화',
                          '수',
                          '목',
                          '금',
                          '토',
                          '일'
                        ];
                        final TextEditingController dateController =
                            TextEditingController(
                                text:
                                    DateFormat('yyyy-MM-dd').format(selectDay));
                        final TextEditingController timeController =
                            TextEditingController(
                                text: '$initialHour:$initialMinute');
                        final TextEditingController countController =
                            TextEditingController();
                        final TextEditingController addressController =
                            TextEditingController();

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFA48AFF),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                '수업 날짜',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: SizedBox(
                                              height: 32,
                                              child: TextField(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        height: 400, // 모달 높이 크기
                                                        width: 400,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors
                                                              .white, // 모달 배경색
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                20), // 모달 전체 라운딩 처리
                                                          ),
                                                        ),
                                                        child: TableCalendar(
                                                          // 달에 첫 날
                                                          firstDay: DateTime(
                                                              now.year - 1,
                                                              now.month,
                                                              1),
                                                          // 달에 마지막 날
                                                          lastDay: DateTime(
                                                              now.year + 10,
                                                              12,
                                                              31),
                                                          focusedDay: selectDay,
                                                          calendarFormat:
                                                              calendarFormat,
                                                          locale: 'ko-KR',
                                                          headerStyle:
                                                              const HeaderStyle(
                                                            titleCentered: true,
                                                            formatButtonVisible:
                                                                false,
                                                          ),
                                                          calendarStyle:
                                                              CalendarStyle(
                                                            selectedDecoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFFA48AFF),
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            defaultDecoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              shape: BoxShape
                                                                  .rectangle,
                                                            ),
                                                            todayDecoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .blueAccent
                                                                  .shade100,
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                          ),
                                                          selectedDayPredicate:
                                                              (day) {
                                                            return isSameDay(
                                                                selectDay, day);
                                                          },
                                                          // 사용자가 캘린더에 요일을 클릭했을 때
                                                          onDaySelected:
                                                              (selectedDay,
                                                                  focusedDay) {
                                                            selectDay =
                                                                selectedDay;
                                                            now = focusedDay;

                                                            ref
                                                                .read(selectDateProvider
                                                                    .notifier)
                                                                .update((state) =>
                                                                    selectDay);

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          onPageChanged:
                                                              (focusedDay) {
                                                            now = focusedDay;
                                                          },
                                                          calendarBuilders:
                                                              CalendarBuilders(
                                                            dowBuilder:
                                                                (context, day) {
                                                              return Center(
                                                                child: Text(
                                                                  days[day
                                                                      .weekday],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                controller: dateController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFA48AFF),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                '수업 시간',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: SizedBox(
                                              height: 32,
                                              child: TextField(
                                                onTap: () async {
                                                  final TimeOfDay? timeOfDay =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime: initialTime,
                                                    initialEntryMode:
                                                        TimePickerEntryMode
                                                            .inputOnly,
                                                  );
                                                  if (timeOfDay != null) {
                                                    String hour = timeOfDay.hour
                                                        .toString()
                                                        .padLeft(2, '0');
                                                    String minute = timeOfDay
                                                        .minute
                                                        .toString()
                                                        .padLeft(2, '0');
                                                    timeController.text =
                                                        '$hour:$minute';
                                                  }
                                                },
                                                controller: timeController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFA48AFF),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                '수업 회차',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: SizedBox(
                                              height: 32,
                                              child: TextField(
                                                controller: countController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  suffixIcon: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFA48AFF),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                '수업 장소',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: SizedBox(
                                              height: 32,
                                              child: TextField(
                                                controller: addressController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  suffixIcon: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      index == newDetailList.length
                                          ? GestureDetector(
                                              onTap: () {
                                                final detailData = {
                                                  'date': dateController.text,
                                                  'time': timeController.text,
                                                  'count': countController.text,
                                                  'address':
                                                      addressController.text,
                                                };
                                                onAddTap(detailData);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 40,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade400,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final detail = {
                                    'date': dateController.text,
                                    'time': timeController.text,
                                    'count': countController.text,
                                    'address': addressController.text,
                                  };
                                  onRemoveTap(detail);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom:
                                        index == newDetailList.length ? 40 : 0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    // GestureDetector(
                    //   onTap: onAddTap,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Container(
                    //         decoration: BoxDecoration(
                    //           color: Colors.green.shade400,
                    //           borderRadius: BorderRadius.circular(20),
                    //         ),
                    //         child: const Icon(
                    //           Icons.add_circle_outline,
                    //           color: Colors.white,
                    //           size: 40,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      // expands: true,
                      maxLines: 10,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
            onPressed: () {},
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
                    '저장하기',
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
