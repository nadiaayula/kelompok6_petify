import 'package:flutter/material.dart';

class CalendarModal extends StatefulWidget {
  const CalendarModal({Key? key}) : super(key: key);

  @override
  State<CalendarModal> createState() => _CalendarModalState();
}

class _CalendarModalState extends State<CalendarModal> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  int? _selectedDay;

  List<String> _months = [
    'JANUARI', 'FEBRUARI', 'MARET', 'APRIL', 'MEI', 'JUNI',
    'JULI', 'AGUSTUS', 'SEPTEMBER', 'OKTOBER', 'NOVEMBER', 'DESEMBER'
  ];

  List<String> _weekDays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  int _getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month/Year Header with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                '${_months[_currentMonth.month - 1]} ${_currentMonth.year}',
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right, size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Week days header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekDays.asMap().entries.map((entry) {
              int index = entry.key;
              String day = entry.value;
              Color textColor = Colors.black87;
              
              if (index == 0) {
                textColor = const Color(0xFFFF6B6B); // Sunday - Red
              } else if (index == 5) {
                textColor = const Color(0xFF4CAF50); // Friday - Green
              }
              
              return SizedBox(
                width: 36,
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 12),
          
          // Calendar grid
          _buildCalendarGrid(),
          
          const SizedBox(height: 24),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_selectedDay != null) {
                  final selectedDate = DateTime(
                    _currentMonth.year,
                    _currentMonth.month,
                    _selectedDay!,
                  );
                  Navigator.pop(context, selectedDate);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    int daysInMonth = _getDaysInMonth(_currentMonth);
    int firstDayOfWeek = _getFirstDayOfMonth(_currentMonth);
    int daysInPreviousMonth = _getDaysInMonth(
      DateTime(_currentMonth.year, _currentMonth.month - 1),
    );

    List<Widget> dayWidgets = [];

    // Previous month days (greyed out)
    for (int i = firstDayOfWeek - 1; i >= 0; i--) {
      dayWidgets.add(_buildDayCell(
        daysInPreviousMonth - i,
        isOtherMonth: true,
      ));
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(_buildDayCell(day));
    }

    // Next month days (greyed out)
    int remainingCells = 42 - dayWidgets.length; // 6 rows * 7 days
    for (int day = 1; day <= remainingCells; day++) {
      dayWidgets.add(_buildDayCell(day, isOtherMonth: true));
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(int day, {bool isOtherMonth = false}) {
    bool isSelected = _selectedDay == day && !isOtherMonth;

    return GestureDetector(
      onTap: isOtherMonth
          ? null
          : () {
              setState(() {
                _selectedDay = day;
              });
            },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B6B) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isOtherMonth
                  ? const Color(0xFFD0D0D0)
                  : isSelected
                      ? Colors.white
                      : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

// Fungsi helper untuk menampilkan calendar modal
void showCalendarModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: const CalendarModal(),
    ),
  );
}
