import 'package:flutter/material.dart';

enum HistoryFilter {
  all,
  poinTerbanyak,
  vaksinasi,
  cekKesehatan,
  anjing,
  kucing,
}

class HistoryData {
  final String type;
  final String animal;
  final String title;
  final String subtitle;
  final int points;
  final String time;
  final String date;
  final String asset;

  HistoryData({
    required this.type,
    required this.animal,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.time,
    required this.date,
    required this.asset,
  });
}

final List<HistoryData> historyList = [
  HistoryData(
    type: "vaksinasi",
    animal: "kucing",
    title: "Vaksinasi",
    subtitle: "Mendapatkan point sebesar",
    points: 200,
    time: "12.58",
    date: "Kemarin",
    asset: "assets/images/kucing1.png",
  ),
  HistoryData(
    type: "cek_kesehatan",
    animal: "kucing",
    title: "Cek Kesehatan",
    subtitle: "Mendapatkan point sebesar",
    points: 35,
    time: "08.46",
    date: "Sabtu, 22 Maret 2024",
    asset: "assets/medical_kit.png",
  ),
  HistoryData(
    type: "vaksinasi",
    animal: "anjing",
    title: "Vaksinasi",
    subtitle: "Mendapatkan point sebesar",
    points: 200,
    time: "10.18",
    date: "Jumat, 21 Maret 2024",
    asset: "assets/anjing1.png",
  ),
  HistoryData(
    type: "cek_kesehatan",
    animal: "anjing",
    title: "Cek Kesehatan",
    subtitle: "Mendapatkan point sebesar",
    points: 35,
    time: "09.23",
    date: "Jumat, 21 Maret 2024",
    asset: "assets/medical_kit.png",
  ),
  HistoryData(
    type: "membersihkan",
    animal: "anjing",
    title: "Membersihkan Kandang",
    subtitle: "Mendapatkan point sebesar",
    points: 15,
    time: "09.23",
    date: "Jumat, 21 Maret 2024",
    asset: "assets/sisir.png",
  ),
];

class HistoryPage extends StatelessWidget {
  final HistoryFilter filter;
  HistoryPage({super.key, required this.filter});

  final TextEditingController _searchController = TextEditingController();

  List<HistoryData> getFilteredData() {
    List<HistoryData> result = historyList;

    switch (filter) {
      case HistoryFilter.poinTerbanyak:
        result = [...result]..sort((a, b) => b.points.compareTo(a.points));
        break;
      case HistoryFilter.vaksinasi:
        result = result.where((e) => e.type == "vaksinasi").toList();
        break;
      case HistoryFilter.cekKesehatan:
        result = result.where((e) => e.type == "cek_kesehatan").toList();
        break;
      case HistoryFilter.anjing:
        result = result.where((e) => e.animal == "anjing").toList();
        break;
      case HistoryFilter.kucing:
        result = result.where((e) => e.animal == "kucing").toList();
        break;
      default:
        break;
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((e) {
        return e.title.toLowerCase().contains(query) ||
            e.type.toLowerCase().contains(query) ||
            e.animal.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredData();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Riwayat & Points",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _headerTotalPoints(),
              const SizedBox(height: 20),
              _buildSearchBar(context),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: _buildGroupedHistory(filtered),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerTotalPoints() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF6FF),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Total perolehan",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "1.500",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text("Points"),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.diamond,
                color: Colors.blue,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Pencarian",
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      onChanged: (value) {
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              _showFilterPopup(context);
            },
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedHistory(List<HistoryData> data) {
    Map<String, List<HistoryData>> grouped = {};
    for (var item in data) {
      grouped.putIfAbsent(item.date, () => []);
      grouped[item.date]!.add(item);
    }

    List<Widget> widgets = [];
    grouped.forEach((date, items) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

      for (var item in items) {
        widgets.add(_historyItem(item));
        widgets.add(const SizedBox(height: 16));
      }
    });

    return widgets;
  }

  Widget _historyItem(HistoryData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                data.asset,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  "${data.points} points",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          Text(
            data.time,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        HistoryFilter? selected = filter;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Filter Pencarian",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Cari Berdasarkan",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _filterChip("Poin Terbanyak", HistoryFilter.poinTerbanyak, selected, (v) {
                        setState(() => selected = v);
                      }),
                      _filterChip("Vaksinasi", HistoryFilter.vaksinasi, selected, (v) {
                        setState(() => selected = v);
                      }),
                      _filterChip("Cek Kesehatan", HistoryFilter.cekKesehatan, selected, (v) {
                        setState(() => selected = v);
                      }),
                      _filterChip("Anjing", HistoryFilter.anjing, selected, (v) {
                        setState(() => selected = v);
                      }),
                      _filterChip("Kucing", HistoryFilter.kucing, selected, (v) {
                        setState(() => selected = v);
                      }),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Tutup",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.orange,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HistoryPage(filter: selected ?? filter),
                                ),
                              );
                            },
                            child: const Text(
                              "Lanjutkan",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _filterChip(
    String label,
    HistoryFilter value,
    HistoryFilter? selected,
    Function(HistoryFilter) onSelect,
  ) {
    final bool isSelected = value == selected;

    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}