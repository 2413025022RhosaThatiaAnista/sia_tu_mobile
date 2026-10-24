
import 'package:flutter/material.dart';

class KalenderKegiatanPage extends StatefulWidget {
  const KalenderKegiatanPage({super.key});

  @override
  State<KalenderKegiatanPage> createState() =>
      _KalenderKegiatanPageState();
}

class _KalenderKegiatanPageState
    extends State<KalenderKegiatanPage> {
  static const Color navy = Color(0xFF193F68);
  static const Color blue = Color(0xFF287EB4);
  static const Color background = Color(0xFFF1F5F9);
  static const Color textDark = Color(0xFF34445B);
  static const Color textGrey = Color(0xFF71839D);
  static const Color green = Color(0xFF27AE60);
  static const Color orange = Color(0xFFE67E22);
  static const Color red = Color(0xFFE74C3C);

  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  final List<Map<String, dynamic>> _activities = [];

  final List<String> _months = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<String> _days = const [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  String _formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  List<Map<String, dynamic>> get _selectedActivities {
    final key = _dateKey(_selectedDate);

    final result = _activities
        .where((item) => item['date'] == key)
        .toList();

    result.sort(
      (a, b) => (a['time'] as String)
          .compareTo(b['time'] as String),
    );

    return result;
  }

  List<Map<String, dynamic>> get _upcomingActivities {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final result = _activities.where((item) {
      final date = DateTime.parse(item['date'] as String);
      return !date.isBefore(todayDate);
    }).toList();

    result.sort((a, b) {
      final dateA = DateTime.parse(
        '${a['date']} ${a['time']}',
      );
      final dateB = DateTime.parse(
        '${b['date']} ${b['time']}',
      );
      return dateA.compareTo(dateB);
    });

    return result;
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + offset,
      );
    });
  }

  Future<void> _openActivityForm({
    Map<String, dynamic>? activity,
  }) async {
    final titleController = TextEditingController(
      text: activity?['title']?.toString() ?? '',
    );
    final locationController = TextEditingController(
      text: activity?['location']?.toString() ?? '',
    );
    final descriptionController = TextEditingController(
      text: activity?['description']?.toString() ?? '',
    );

    DateTime date = activity != null
        ? DateTime.parse(activity['date'] as String)
        : _selectedDate;

    TimeOfDay time = const TimeOfDay(hour: 8, minute: 0);

    if (activity != null) {
      final parts = (activity['time'] as String).split(':');
      time = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                activity == null
                    ? 'Tambah Kegiatan'
                    : 'Edit Kegiatan',
                style: const TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _inputField(
                          controller: titleController,
                          label: 'Nama Kegiatan',
                          hint: 'Contoh: Rapat Tata Usaha',
                          icon: Icons.event_note_outlined,
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                              locale: const Locale('id', 'ID'),
                            );

                            if (picked != null) {
                              setDialogState(() => date = picked);
                            }
                          },
                          child: _dateTimeField(
                            'Tanggal Kegiatan',
                            _formatDate(date),
                            Icons.calendar_month_outlined,
                          ),
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: time,
                            );

                            if (picked != null) {
                              setDialogState(() => time = picked);
                            }
                          },
                          child: _dateTimeField(
                            'Waktu Kegiatan',
                            time.format(context),
                            Icons.access_time,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _inputField(
                          controller: locationController,
                          label: 'Lokasi',
                          hint: 'Contoh: Ruang Tata Usaha',
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 14),
                        _inputField(
                          controller: descriptionController,
                          label: 'Deskripsi',
                          hint: 'Keterangan kegiatan',
                          icon: Icons.notes_outlined,
                          maxLines: 3,
                          requiredField: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(
                20, 0, 20, 16,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: textGrey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Navigator.pop(dialogContext, {
                      'title': titleController.text.trim(),
                      'date': _dateKey(date),
                      'time':
                          '${time.hour.toString().padLeft(2, '0')}:'
                          '${time.minute.toString().padLeft(2, '0')}',
                      'location': locationController.text.trim(),
                      'description':
                          descriptionController.text.trim(),
                    });
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    locationController.dispose();
    descriptionController.dispose();

    if (!mounted || result == null) return;

    setState(() {
      if (activity == null) {
        _activities.add(result);
      } else {
        final index = _activities.indexOf(activity);
        if (index != -1) {
          _activities[index] = result;
        }
      }

      _selectedDate = DateTime.parse(result['date'] as String);
      _currentMonth = DateTime(
        _selectedDate.year,
        _selectedDate.month,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          activity == null
              ? 'Kegiatan berhasil ditambahkan.'
              : 'Kegiatan berhasil diperbarui.',
        ),
        backgroundColor: green,
      ),
    );
  }

  Future<void> _deleteActivity(
    Map<String, dynamic> activity,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Kegiatan?'),
        content: Text(
          'Kegiatan "${activity['title']}" akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _activities.remove(activity));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kegiatan berhasil dihapus.'),
        backgroundColor: green,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool requiredField = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (requiredField && (value == null || value.trim().isEmpty)) {
          return '$label wajib diisi';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: blue),
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: blue,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _dateTimeField(
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_calendar_outlined, color: blue),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final firstDay = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );

    // Kalender dimulai dari hari Senin.
    final offset = firstDay.weekday - 1;
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;

    final rows = ((offset + daysInMonth) / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: blue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kalender Bulanan',
                      style: TextStyle(
                        color: navy,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_months[_currentMonth.month - 1]} '
                      '${_currentMonth.year}',
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Bulan sebelumnya',
                onPressed: () => _changeMonth(-1),
                icon: const Icon(
                  Icons.chevron_left,
                  color: navy,
                ),
              ),
              IconButton(
                tooltip: 'Bulan berikutnya',
                onPressed: () => _changeMonth(1),
                icon: const Icon(
                  Icons.chevron_right,
                  color: navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: _days.map((day) {
              return Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      day,
                      style: const TextStyle(
                        color: textGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          for (int row = 0; row < rows; row++)
            Row(
              children: List.generate(7, (column) {
                final dayNumber = row * 7 + column - offset + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(
                    child: SizedBox(height: 64),
                  );
                }

                final date = DateTime(
                  _currentMonth.year,
                  _currentMonth.month,
                  dayNumber,
                );

                final isSelected =
                    _dateKey(date) == _dateKey(_selectedDate);
                final isToday =
                    _dateKey(date) == _dateKey(DateTime.now());

                final hasActivity = _activities.any(
                  (item) => item['date'] == _dateKey(date),
                );

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() => _selectedDate = date);
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? navy
                              : isToday
                                  ? blue.withOpacity(0.09)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isToday && !isSelected
                                ? blue
                                : const Color(0xFFE8EDF2),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$dayNumber',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : textDark,
                                fontWeight: isSelected || isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 5),
                            if (hasActivity)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : orange,
                                  shape: BoxShape.circle,
                                ),
                              )
                            else
                              const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.circle, size: 9, color: orange),
              SizedBox(width: 6),
              Text(
                'Tanggal dengan agenda',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.035),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    final date = DateTime.parse(activity['date'] as String);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE8EDF2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: blue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${date.day}',
                  style: const TextStyle(
                    color: navy,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _months[date.month - 1].substring(0, 3).toUpperCase(),
                  style: const TextStyle(
                    color: blue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: const TextStyle(
                    color: navy,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 15,
                      color: textGrey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      activity['time'] as String,
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: textGrey,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        (activity['location'] as String).isEmpty
                            ? 'Lokasi belum diisi'
                            : activity['location'] as String,
                        style: const TextStyle(
                          color: textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                if ((activity['description'] as String).isNotEmpty) ...[
                  const SizedBox(height: 7),
                  Text(
                    activity['description'] as String,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Aksi kegiatan',
            onSelected: (value) {
              if (value == 'edit') {
                _openActivityForm(activity: activity);
              } else if (value == 'delete') {
                _deleteActivity(activity);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Hapus'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgendaPanel() {
    final activities = _selectedActivities;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Agenda Terpilih',
                  style: TextStyle(
                    color: navy,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Tambah kegiatan pada tanggal terpilih',
                onPressed: () => _openActivityForm(),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: blue,
                ),
              ),
            ],
          ),
          Text(
            _formatDate(_selectedDate),
            style: const TextStyle(
              color: textGrey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          if (activities.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    size: 35,
                    color: textGrey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Belum ada kegiatan',
                    style: TextStyle(
                      color: textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Tambahkan agenda untuk tanggal ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            ...activities.map(_buildActivityCard),
        ],
      ),
    );
  }

  Widget _buildUpcomingPanel() {
    final activities = _upcomingActivities.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.upcoming_outlined,
                color: blue,
              ),
              SizedBox(width: 10),
              Text(
                'Kegiatan Mendatang',
                style: TextStyle(
                  color: navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (activities.isEmpty)
            const Text(
              'Belum ada agenda mendatang.',
              style: TextStyle(color: textGrey),
            )
          else
            ...activities.map((activity) {
              final date = DateTime.parse(activity['date'] as String);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: blue.withOpacity(0.10),
                  child: const Icon(
                    Icons.event_note_outlined,
                    color: blue,
                  ),
                ),
                title: Text(
                  activity['title'] as String,
                  style: const TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text(
                  '${_formatDate(date)} • ${activity['time']}',
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 11,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                    _currentMonth = DateTime(date.year, date.month);
                  });
                },
              );
            }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 950;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isWide ? 28 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: blue.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          color: blue,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kalender Kegiatan',
                              style: TextStyle(
                                color: navy,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Kelola jadwal kegiatan tata usaha sekolah',
                              style: TextStyle(
                                color: textGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isWide)
                        ElevatedButton.icon(
                          onPressed: () => _openActivityForm(),
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Kegiatan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      _summaryCard(
                        'Total Kegiatan',
                        '${_activities.length}',
                        Icons.event_note_outlined,
                        blue,
                      ),
                      _summaryCard(
                        'Agenda Hari Ini',
                        '${_activities.where((item) => item['date'] == _dateKey(DateTime.now())).length}',
                        Icons.today_outlined,
                        green,
                      ),
                      _summaryCard(
                        'Agenda Mendatang',
                        '${_upcomingActivities.length}',
                        Icons.upcoming_outlined,
                        orange,
                      ),
                    ].map((widget) {
                      return SizedBox(
                        width: isWide
                            ? (constraints.maxWidth - 84) / 3
                            : (constraints.maxWidth - 14) / 2,
                        child: widget,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),

                  if (!isWide) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openActivityForm(),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Kegiatan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _buildCalendar(),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              _buildAgendaPanel(),
                              const SizedBox(height: 20),
                              _buildUpcomingPanel(),
                            ],
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _buildCalendar(),
                    const SizedBox(height: 18),
                    _buildAgendaPanel(),
                    const SizedBox(height: 18),
                    _buildUpcomingPanel(),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
