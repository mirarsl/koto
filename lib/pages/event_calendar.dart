import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../const.dart';
import 'news_det.dart';

class EventCalendar extends StatefulWidget {
  final List source;
  const EventCalendar({
    required this.source,
    Key? key,
  }) : super(key: key);

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  List<Meeting> meetings = <Meeting>[];
  void _getDataSource() {
    meetings = [];
    for (var data in widget.source) {
      DateTime startTime = DateTime.parse(data.children[2].text);
      DateTime endTime = DateTime.parse(data.children[3].text);
      meetings.add(
        Meeting(
          data.children[1].text,
          startTime,
          endTime,
          mainColor,
          false,
          data.children[0].text,
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    _getDataSource();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 1,
        dataSource: MeetingDataSource(meetings),
        todayHighlightColor: mainColor,
        cellBorderColor: mainColor,
        backgroundColor: Colors.white,
        showCurrentTimeIndicator: true,
        showNavigationArrow: true,
        showDatePickerButton: true,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          numberOfWeeksInView: 6,
          appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          appointmentDisplayCount: 1,
          agendaItemHeight: 80,
          agendaViewHeight: 120,
          agendaStyle: AgendaStyle(
            backgroundColor: Colors.transparent,
            appointmentTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            dayTextStyle: TextStyle(
              color: mainColor,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            dateTextStyle: TextStyle(
              color: mainColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
          monthCellStyle: MonthCellStyle(
            trailingDatesTextStyle: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 15,
              color: Colors.black,
            ),
            leadingDatesTextStyle: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 15,
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            todayBackgroundColor: mainColor,
            leadingDatesBackgroundColor: Color(0xFFEEEEEE),
            trailingDatesBackgroundColor: Color(0xFFEEEEEE),
          ),
        ),
        appointmentBuilder: (con, el) {
          return RawMaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDet(
                    'http://koto.org.tr/app_bilgi_bankasi_etkinlik_det.php?id=${el.appointments.first.id}',
                  ),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    el.appointments.first.eventName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "Detayları Gör",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.id,
  );

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String id;
}
