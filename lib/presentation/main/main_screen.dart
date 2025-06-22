import 'package:ai_parking/presentation/community/community_screen.dart';
import 'package:ai_parking/presentation/parking_status/parking_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    _HomeScreen(),
    CommunityScreen(),
    Scaffold(body: Center(child: Text('내 정보'))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined),
            activeIcon: Icon(Icons.feed),
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0066CC),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'AI 주차관리',
              style: GoogleFonts.inter(
                color: const Color(0xFF004A99),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '[아파트A]',
              style: GoogleFonts.inter(
                color: const Color(0xFF454545),
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• 동별 주차 현황',
                style: GoogleFonts.inter(
                  color: const Color(0xFF454545),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              _ParkingStatusCard(
                dong: '101동',
                available: 12,
                total: 50,
                progress: 12 / 50,
              ),
              const SizedBox(height: 12),
              _ParkingStatusCard(
                dong: '102동',
                available: 5,
                total: 30,
                progress: 5 / 30,
              ),
              const SizedBox(height: 12),
              _ParkingStatusCard(
                dong: '103동',
                available: 20,
                total: 40,
                progress: 20 / 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParkingStatusCard extends StatelessWidget {
  final String dong;
  final int available;
  final int total;
  final double progress;

  const _ParkingStatusCard({
    required this.dong,
    required this.available,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ParkingStatusScreen(
              dong: dong,
              available: available,
              total: total,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.business, size: 40, color: Color(0xFF454545)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dong,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF454545),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '남은 $available / $total (${(progress * 100).toStringAsFixed(0)}%)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF454545),
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFF5F5F5),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF0066CC),
                      ),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
