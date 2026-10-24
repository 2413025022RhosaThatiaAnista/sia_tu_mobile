import 'package:flutter/material.dart';

/// Kalender akademik untuk SIA-TU SEKOLAH.
///
/// Saat ini kegiatan disimpan sementara di memori aplikasi.
/// Nanti, fungsi _loadEvents(), _saveEvent(), dan _deleteEvent()
/// dapat dihubungkan ke PHP API yang mengakses MySQL.
class KalenderAkademik extends StatefulWidget {
  const KalenderAkademik({super.key});

  @override
  State<KalenderAkademik> createState() => _KalenderAkademikState();
}

class _KalenderAkademikState extends State<KalenderAkademik> {
  static const Color navy = Color(0xFF193F68);
  static const Color blue = Color(0xFF287EB4);
  static const Color textDark = Color(0xFF34445B);
  static const Color textGrey = Color(0xFF71839D);
  static const Color pageBorder = Color(0xFFE1E8F0);

  DateTime _displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // Data contoh/in-memory. Data ini belum tersimpan ke database.
  final List<_AcademicEvent> _events = [];

  static const List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  static const List<String> _weekDays = [
    'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min',
  ];

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isToday(DateTime date) => _sameDay(date, DateTime.now());

  List<_AcademicEvent> get _selectedEvents => _events
      .where((event) => _sameDay(event.date, _selectedDate))
      .toList()
    ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

  void _changeMonth(int amount) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + amount,
        1,
      );
      // Pilih tanggal yang valid pada bulan baru.
      final lastDay = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
        0,
      ).day;
      _selectedDate = DateTime(
        _displayedMonth.year,
        _displayedMonth.month,
        _selectedDate.day > lastDay ? lastDay : _selectedDate.day,
      );
    });
  }

  Future<void> _showEventForm({_AcademicEvent? event}) async {
    final titleController = TextEditingController(text: event?.title ?? '');
    final descriptionController =
        TextEditingController(text: event?.description ?? '');
    DateTime eventDate = event?.date ?? _selectedDate;
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<_AcademicEvent>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(event == null ? 'Tambah Kegiatan' : 'Edit Kegiatan'),
              content: SizedBox(
                width: 440,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: titleController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Nama kegiatan *',
                            hintText: 'Contoh: Rapat guru',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.event_note),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Nama kegiatan wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: descriptionController,
                          minLines: 2,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Keterangan',
                            hintText: 'Tambahkan detail kegiatan (opsional)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.notes),
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Tanggal kegiatan',
                          style: TextStyle(
                            color: textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: dialogContext,
                              initialDate: eventDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              locale: const Locale('id', 'ID'),
                              builder: (context, child) => Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: navy,
                                    onPrimary: Colors.white,
                                    onSurface: textDark,
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                eventDate = DateTime(
                                  picked.year,
                                  picked.month,
                                  picked.day,
                                );
                              });
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: Text(
                            '${eventDate.day} ${_monthNames[eventDate.month - 1]} ${eventDate.year}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: navy),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    Navigator.pop(
                      dialogContext,
                      _AcademicEvent(
                        id: event?.id ??
                            DateTime.now().microsecondsSinceEpoch.toString(),
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        date: eventDate,
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();

    if (result == null || !mounted) return;

    setState(() {
      final oldIndex = _events.indexWhere((item) => item.id == result.id);
      if (oldIndex >= 0) {
        _events[oldIndex] = result;
      } else {
        _events.add(result);
      }
      _selectedDate = result.date;
      _displayedMonth = DateTime(result.date.year, result.date.month);
    });

    // TODO: Hubungkan ke PHP API/MySQL di sini.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event == null
              ? 'Kegiatan berhasil ditambahkan (sementara di aplikasi)'
              : 'Kegiatan berhasil diperbarui (sementara di aplikasi)',
        ),
      ),
    );
  }

  Future<void> _confirmDelete(_AcademicEvent event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus kegiatan?'),
        content: Text('Kegiatan "${event.title}" akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _events.removeWhere((item) => item.id == event.id));

    // TODO: Hubungkan ke endpoint DELETE PHP API/MySQL di sini.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kegiatan dihapus dari daftar sementara'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 650;
    final firstDay = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    );
    final offset = firstDay.weekday - 1;
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final cellCount = ((offset + daysInMonth + 6) ~/ 7) * 7;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFF0F3F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, color: navy, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'KALENDER AKADEMIK',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    final now = DateTime.now();
                    _displayedMonth = DateTime(now.year, now.month);
                    _selectedDate = DateTime(now.year, now.month, now.day);
                  });
                },
                icon: const Icon(Icons.today, size: 17),
                label: const Text('Hari ini'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                tooltip: 'Bulan sebelumnya',
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left, color: navy, size: 28),
              ),
              Expanded(
                child: Text(
                  '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Bulan berikutnya',
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right, color: navy, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(_weekDays.length, (index) {
              return Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _weekDays[index],
                      style: TextStyle(
                        color: index == 6 ? Colors.red : textGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 11 : 14,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = isMobile ? 3.0 : 6.0;
              final cellWidth = (constraints.maxWidth - spacing * 6) / 7;
              final cellHeight = isMobile
                  ? (cellWidth * 0.95).clamp(43.0, 65.0).toDouble()
                  : (cellWidth * 0.78).clamp(70.0, 120.0).toDouble();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cellCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  mainAxisExtent: cellHeight,
                ),
                itemBuilder: (context, index) {
                  final dayNumber = index - offset + 1;
                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox.shrink();
                  }

                  final date = DateTime(
                    _displayedMonth.year,
                    _displayedMonth.month,
                    dayNumber,
                  );
                  final isSelected = _sameDay(date, _selectedDate);
                  final isToday = _isToday(date);
                  final isSunday = date.weekday == DateTime.sunday;
                  final hasEvents =
                      _events.any((item) => _sameDay(item.date, date));

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        setState(() => _selectedDate = date);

                        // Klik tanggal langsung membuka formulir:
                        // edit kegiatan yang sudah ada, atau tambah kegiatan baru.
                        final eventsOnDate = _events
                            .where((item) => _sameDay(item.date, date))
                            .toList();

                        if (eventsOnDate.isNotEmpty) {
                          await _showEventForm(event: eventsOnDate.first);
                        } else {
                          await _showEventForm();
                        }
                      },
                      child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? navy
                            : isToday
                                ? const Color(0xFFEAF3FB)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? navy
                              : isToday
                                  ? blue
                                  : pageBorder,
                          width: isSelected || isToday ? 1.5 : 1,
                        ),
                      ),
                      padding: EdgeInsets.all(isMobile ? 4 : 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              '$dayNumber',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : isSunday
                                        ? Colors.red
                                        : textDark,
                                fontSize: isMobile ? 11 : 14,
                                fontWeight: isToday || isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (hasEvents) ...[
                            const Spacer(),
                            Center(
                              child: Container(
                                width: isMobile ? 5 : 7,
                                height: isMobile ? 5 : 7,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          const Divider(color: pageBorder),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Kegiatan ${_selectedDate.day} ${_monthNames[_selectedDate.month - 1]} ${_selectedDate.year}',
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () => _showEventForm(),
                style: FilledButton.styleFrom(
                  backgroundColor: navy,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 16,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: Text(isMobile ? 'Tambah' : 'Tambah kegiatan'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedEvents.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: pageBorder),
              ),
              child: const Column(
                children: [
                  Icon(Icons.event_available, size: 30, color: textGrey),
                  SizedBox(height: 8),
                  Text(
                    'Belum ada kegiatan pada tanggal ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textGrey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Pilih tanggal lain atau tekan Tambah kegiatan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textGrey, fontSize: 12),
                  ),
                ],
              ),
            )
          else
            ..._selectedEvents.map(_buildEventCard),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.info_outline, size: 15, color: textGrey),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Data saat ini sementara. Hubungkan ke PHP API/MySQL agar tersimpan permanen.',
                  style: TextStyle(color: textGrey, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(_AcademicEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: pageBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE4EFF9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.event_note, color: navy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    event.description,
                    style: const TextStyle(
                      color: textGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 5),
                Text(
                  '${event.date.day} ${_monthNames[event.date.month - 1]} ${event.date.year}',
                  style: const TextStyle(color: textGrey, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit kegiatan',
            onPressed: () => _showEventForm(event: event),
            icon: const Icon(Icons.edit_outlined, color: blue, size: 20),
          ),
          IconButton(
            tooltip: 'Hapus kegiatan',
            onPressed: () => _confirmDelete(event),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }
}

class _AcademicEvent {
  const _AcademicEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
}
