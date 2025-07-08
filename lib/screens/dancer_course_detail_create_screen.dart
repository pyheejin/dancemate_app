import 'dart:convert';

import 'package:dancemate_app/provider/dancer_provider.dart';
import 'package:dancemate_app/provider/image_provider.dart';
import 'package:dancemate_app/provider/lesson_provider.dart';
import 'package:dancemate_app/widgets/error.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class DancerCourseDetailCreateScreen extends ConsumerWidget {
  const DancerCourseDetailCreateScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String imagePath = ref.watch(selectLessonImagePathProvider);
    String title = ref.watch(courseTitleProvider);
    String description = ref.watch(courseDescriptionProvider);

    List<XFile> imagesPath = ref.watch(selectLessonImagesPathProvider);

    Future<void> pickImage() async {
      ImagePicker().pickMultiImage(limit: 5).then(
        (images) {
          if (images.isNotEmpty) {
            ref
                .read(selectLessonImagesPathProvider.notifier)
                .update((state) => images);
          }
        },
      );
      // ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      //   if (image != null) {
      //     ref
      //         .read(selectLessonImagePathProvider.notifier)
      //         .update((state) => image.path);
      //   }
      // });
    }

    final TextEditingController titleController =
        TextEditingController(text: title);
    final TextEditingController descriptionController =
        TextEditingController(text: description);

    dynamic newDetailList = ref.watch(dancerCourseProvider);

    DateTime now = DateTime.now();
    TimeOfDay initialStartTime = TimeOfDay.now();
    String initialStartHour = initialStartTime.hour.toString().padLeft(2, '0');
    String initialStartMinute =
        initialStartTime.minute.toString().padLeft(2, '0');
    String startTime = '$initialStartHour:$initialStartMinute';

    TimeOfDay initialEndTime =
        TimeOfDay.fromDateTime(now.add(const Duration(hours: 2)));
    String initialEndHour = initialEndTime.hour.toString().padLeft(2, '0');
    String initialEndMinute =
        initialStartTime.minute.toString().padLeft(2, '0');
    String endTime = '$initialEndHour:$initialEndMinute';

    CalendarFormat calendarFormat = CalendarFormat.month;
    DateTime selectDay = ref.watch(selectDateProvider);
    List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];

    final TextEditingController dateController =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(selectDay));
    final TextEditingController startTimeController =
        TextEditingController(text: startTime);
    final TextEditingController endTimeController =
        TextEditingController(text: endTime);
    final TextEditingController countController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    final TextEditingController detailDateController = TextEditingController();
    final TextEditingController detailStartTimeController =
        TextEditingController();
    final TextEditingController detailEndTimeController =
        TextEditingController();
    final TextEditingController detailCountController = TextEditingController();
    final TextEditingController detailAddressController =
        TextEditingController();

    void onDateModalBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400, // 모달 높이 크기
            width: 400,
            decoration: const BoxDecoration(
              color: Colors.white, // 모달 배경색
              borderRadius: BorderRadius.all(
                Radius.circular(20), // 모달 전체 라운딩 처리
              ),
            ),
            child: TableCalendar(
              // 달에 첫 날
              firstDay: DateTime(now.year - 1, now.month, 1),
              // 달에 마지막 날
              lastDay: DateTime(now.year + 10, 12, 31),
              focusedDay: selectDay,
              calendarFormat: calendarFormat,
              locale: 'ko-KR',
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFFA48AFF),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                ),
                defaultDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent.shade100,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(selectDay, day);
              },
              // 사용자가 캘린더에 요일을 클릭했을 때
              onDaySelected: (selectedDay, focusedDay) {
                selectDay = selectedDay;
                now = focusedDay;

                ref
                    .read(selectDateProvider.notifier)
                    .update((state) => selectDay);

                dateController.text =
                    DateFormat('yyyy-MM-dd').format(selectDay);

                Navigator.pop(context);
              },
              onPageChanged: (focusedDay) {
                now = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  return Center(
                    child: Text(
                      days[day.weekday],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }

    void onDetailDateModalBottomSheet(dynamic courseDetail) {
      String date = courseDetail['course_date'].split(' ')[0];
      String startTime = courseDetail['start_time'];
      String endTime = courseDetail['end_time'];
      String title = courseDetail['title'];
      String address = courseDetail['address'];
      String addressDetail = courseDetail['address_detail'];

      DateTime detailSelectDay = ref.watch(selectDetailDateProvider);

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400, // 모달 높이 크기
            width: 400,
            decoration: const BoxDecoration(
              color: Colors.white, // 모달 배경색
              borderRadius: BorderRadius.all(
                Radius.circular(20), // 모달 전체 라운딩 처리
              ),
            ),
            child: TableCalendar(
              // 달에 첫 날
              firstDay: DateTime(now.year - 1, now.month, 1),
              // 달에 마지막 날
              lastDay: DateTime(now.year + 10, 12, 31),
              focusedDay: detailSelectDay,
              calendarFormat: calendarFormat,
              locale: 'ko-KR',
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFFA48AFF),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                ),
                defaultDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent.shade100,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(detailSelectDay, day);
              },
              // 사용자가 캘린더에 요일을 클릭했을 때
              onDaySelected: (selectedDay, focusedDay) {
                // date = selectedDay;
                detailSelectDay = selectedDay;
                now = focusedDay;

                ref
                    .read(selectDetailDateProvider.notifier)
                    .update((state) => detailSelectDay);

                print(detailSelectDay);

                detailDateController.text =
                    DateFormat('yyyy-MM-dd').format(detailSelectDay);

                Navigator.pop(context);
              },
              onPageChanged: (focusedDay) {
                now = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  return Center(
                    child: Text(
                      days[day.weekday],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }

    void onCourseDetailTap(int index, dynamic courseDetail) {
      print(index);
      String date = courseDetail['course_date'].split(' ')[0];
      String startTime = courseDetail['start_time'];
      String endTime = courseDetail['end_time'];
      String title = courseDetail['title'];
      String address = courseDetail['address'];
      String addressDetail = courseDetail['address_detail'];

      detailDateController.text = date;
      detailStartTimeController.text = startTime;
      detailEndTimeController.text = endTime;
      detailCountController.text = title;
      detailAddressController.text = address;

      TimeOfDay afterStartTime = TimeOfDay(
        hour: int.parse(startTime.split(':')[0]),
        minute: int.parse(startTime.split(':')[1]),
      );
      TimeOfDay afterEndTime = TimeOfDay(
        hour: int.parse(endTime.split(':')[0]),
        minute: int.parse(endTime.split(':')[1]),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 420,
              decoration: const BoxDecoration(
                color: Colors.white, // 모달 배경색
                borderRadius: BorderRadius.all(
                  Radius.circular(15), // 모달 전체 라운딩 처리
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    const Text(
                      '회차 수정하기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
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
                            height: 40,
                            child: TextField(
                              onTap: () {
                                onDetailDateModalBottomSheet(courseDetail);
                              },
                              controller: detailDateController,
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: Text(
                              '시작 시간',
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
                            height: 40,
                            child: TextField(
                              onTap: () async {
                                final TimeOfDay? timeOfDay =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: afterStartTime,
                                  initialEntryMode:
                                      TimePickerEntryMode.inputOnly,
                                );
                                if (timeOfDay != null) {
                                  String hour =
                                      timeOfDay.hour.toString().padLeft(2, '0');
                                  String minute = timeOfDay.minute
                                      .toString()
                                      .padLeft(2, '0');
                                  detailStartTimeController.text =
                                      '$hour:$minute';

                                  String endHour = (timeOfDay.hour + 2)
                                      .toString()
                                      .padLeft(2, '0');
                                  String endMinute = timeOfDay.minute
                                      .toString()
                                      .padLeft(2, '0');
                                  detailEndTimeController.text =
                                      '$endHour:$endMinute';
                                }
                              },
                              controller: detailStartTimeController,
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: Text(
                              '종료 시간',
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
                            height: 40,
                            child: TextField(
                              onTap: () async {
                                final TimeOfDay? timeOfDay =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: afterEndTime,
                                  initialEntryMode:
                                      TimePickerEntryMode.inputOnly,
                                );
                                if (timeOfDay != null) {
                                  String hour =
                                      timeOfDay.hour.toString().padLeft(2, '0');
                                  String minute = timeOfDay.minute
                                      .toString()
                                      .padLeft(2, '0');
                                  detailEndTimeController.text =
                                      '$hour:$minute';
                                }
                              },
                              controller: detailEndTimeController,
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
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
                            height: 40,
                            child: TextField(
                              controller: detailCountController,
                              decoration: InputDecoration(
                                hintText: 'N회차',
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
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
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
                            height: 40,
                            child: TextField(
                              controller: detailAddressController,
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
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.redAccent,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              child: Text(
                                '취소',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final detail = {
                              'idx': index,
                              'course_date': detailDateController.text,
                              'start_time': detailStartTimeController.text,
                              'end_time': detailEndTimeController.text,
                              'title': detailCountController.text,
                              'address': detailAddressController.text,
                              'address_detail': detailAddressController.text,
                            };
                            ref
                                .read(dancerCourseProvider.notifier)
                                .updateCourseDetail(index, detail);

                            ref
                                .read(courseTitleProvider.notifier)
                                .update((state) => titleController.text);

                            ref
                                .read(courseDescriptionProvider.notifier)
                                .update((state) => descriptionController.text);

                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFA48AFF),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              child: Text(
                                '저장',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFA48AFF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    void onAddTap() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 420,
              decoration: const BoxDecoration(
                color: Colors.white, // 모달 배경색
                borderRadius: BorderRadius.all(
                  Radius.circular(15), // 모달 전체 라운딩 처리
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    const Text(
                      '회차 추가하기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
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
                            height: 40,
                            child: TextField(
                              onTap: onDateModalBottomSheet,
                              controller: dateController,
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: Text(
                              '시작 시간',
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
                            height: 40,
                            child: TextField(
                              onTap: () async {
                                final TimeOfDay? timeOfDay =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: initialStartTime,
                                  initialEntryMode:
                                      TimePickerEntryMode.inputOnly,
                                );
                                if (timeOfDay != null) {
                                  String hour =
                                      timeOfDay.hour.toString().padLeft(2, '0');
                                  String minute = timeOfDay.minute
                                      .toString()
                                      .padLeft(2, '0');
                                  startTimeController.text = '$hour:$minute';

                                  String endHour = (timeOfDay.hour + 2)
                                      .toString()
                                      .padLeft(2, '0');
                                  String endMinute = timeOfDay.minute
                                      .toString()
                                      .padLeft(2, '0');
                                  endTimeController.text =
                                      '$endHour:$endMinute';
                                }
                              },
                              controller: startTimeController,
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: Text(
                              '종료 시간',
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
                            height: 40,
                            child: TextField(
                              onTap: () async {
                                final TimeOfDay? timeOfDay =
                                    await showTimePicker(
                                  context: context,
                                  initialTime: initialEndTime,
                                  initialEntryMode:
                                      TimePickerEntryMode.inputOnly,
                                );
                                if (timeOfDay != null) {
                                  String hour =
                                      timeOfDay.hour.toString().padLeft(2, '0');
                                  String minute = timeOfDay.minute
                                      .toString()
                                      .padLeft(2, '0');
                                  endTimeController.text = '$hour:$minute';
                                }
                              },
                              controller: endTimeController,
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
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
                            height: 40,
                            child: TextField(
                              controller: countController,
                              decoration: InputDecoration(
                                hintText: 'N회차',
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
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFA48AFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
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
                            height: 40,
                            child: TextField(
                              controller: addressController,
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
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.redAccent,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              child: Text(
                                '취소',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final detail = {
                              'idx': newDetailList.length,
                              'course_date': dateController.text,
                              'start_time': startTimeController.text,
                              'end_time': endTimeController.text,
                              'title': countController.text,
                              'address': addressController.text,
                              'address_detail': addressController.text,
                            };

                            ref
                                .read(dancerCourseProvider.notifier)
                                .addCourseDetail(detail);

                            ref
                                .read(courseTitleProvider.notifier)
                                .update((state) => titleController.text);

                            ref
                                .read(courseDescriptionProvider.notifier)
                                .update((state) => descriptionController.text);

                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFA48AFF),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              child: Text(
                                '저장',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFA48AFF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    void onRemoveTap(Map<String, dynamic> detail) {
      ref.read(dancerCourseProvider.notifier).removeCourseDetail(detail);
    }

    void onSaveTap() async {
      final detail = {
        'status': 1,
        'title': titleController.text,
        'description': descriptionController.text,
        'detail_list': newDetailList,
      };

      final result =
          await ref.read(dancerCourseProvider.notifier).saveCourse(detail);

      if (result != null) {
        if (result['result_code'] == 200) {
          final List<MultipartFile> images = imagesPath
              .map((img) => MultipartFile.fromFileSync(img.path))
              .toList();
          // 파일 경로를 통해 formData 생성
          FormData bodyData = FormData.fromMap({
            'bucket': 'lesson',
            'lesson_id': result['result_data']['lesson_id'],
            'images': images,
          });

          final imageResult =
              await ref.watch(postImageUploadProvider(bodyData).future);
          final response = jsonDecode(imageResult.toString());
          if (response['result_code'] == 200) {
            ref.refresh(getDancerCourseProvider);
          } else {
            errorAlert(context, response['result_msg']);
          }

          Navigator.pop(context);
          ref.refresh(getDancerCourseProvider);
          ref.refresh(dancerCourseProvider);
        } else {
          errorAlert(context, result['result_msg']);
        }
      }
    }

    int initialImagePage = ref.watch(initialImagePageProvider);

    final pageController = PageController(
      initialPage: initialImagePage,
      viewportFraction: 0.8,
      keepPage: true,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.refresh(dancerCourseProvider);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    child: imagesPath.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 40,
                              ),
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 40,
                                color: Colors.black87,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: imagesPath.length,
                            itemBuilder: (BuildContext context, int index) {
                              final path = imagesPath[index].path;
                              return Image.asset(
                                width: 430,
                                height: 220,
                                path,
                                fit: BoxFit.fill,
                              );
                            },
                          ),
                  ),
                  imagesPath.isEmpty
                      ? Container()
                      : Positioned(
                          left: (MediaQuery.of(context).size.width / 2) -
                              (imagesPath.length * 10),
                          bottom: 10,
                          child: Row(
                            children: [
                              Center(
                                child: SmoothPageIndicator(
                                  controller: pageController,
                                  count: imagesPath.length,
                                  effect: const SwapEffect(
                                    dotHeight: 12,
                                    dotWidth: 12,
                                    dotColor: Color(0xFFA48AFF),
                                    activeDotColor: Color(0xFF74D0FF),
                                  ),
                                  onDotClicked: (index) {
                                    ref
                                        .read(initialImagePageProvider.notifier)
                                        .update((state) => index);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                ],
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
                    itemCount: newDetailList.length,
                    itemBuilder: (context, index) {
                      if (newDetailList.length > 0) {
                        return GestureDetector(
                          onTap: () {
                            onCourseDetailTap(index, newDetailList[index]);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 5,
                                  ),
                                  child: Column(
                                    children: [
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
                                                '수업 회차',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            '${newDetailList[index]['title']}',
                                            style: const TextStyle(
                                              fontSize: 17,
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
                                                '수업 날짜',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            newDetailList[index]['course_date']
                                                .split(' ')[0],
                                            style: const TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFA48AFF),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 15,
                                                  ),
                                                  child: Text(
                                                    '시작 시간',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                newDetailList[index]
                                                    ['start_time'],
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 15),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFA48AFF),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 15,
                                                  ),
                                                  child: Text(
                                                    '종료 시간',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                newDetailList[index]
                                                    ['end_time'],
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
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
                                          const SizedBox(width: 15),
                                          Text(
                                            newDetailList[index]['address'],
                                            style: const TextStyle(
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              GestureDetector(
                                onTap: () {
                                  onRemoveTap(newDetailList[index]);
                                },
                                child: Container(
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
                      }
                      return null;
                    },
                  ),
                  GestureDetector(
                    onTap: onAddTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: 40,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10,
                                  right: 15,
                                ),
                                child: Text(
                                  '회차 추가하기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white24,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
            onPressed: onSaveTap,
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
