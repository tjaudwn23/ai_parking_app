/// 메인 화면(MainScreen)
/// - 앱의 메인 화면으로 하단 네비게이션 바를 통해 홈/게시판/내 정보 탭을 전환합니다.
/// - _HomeScreen: 사용자의 아파트 주소 기반으로 동(건물) 리스트를 가져와 주차 상태 카드를 표시합니다.
/// - 각 동 카드를 탭하면 해당 동의 상세 주차 상태 화면으로 이동합니다.
/// - 사용자의 apartmentId를 UserProvider에 자동으로 저장합니다.

import 'package:ai_parking/presentation/community/community_screen.dart';
import 'package:ai_parking/presentation/my_info/my_info_screen.dart';
import 'package:ai_parking/presentation/parking_status/parking_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_parking/data/model/building.dart';
import 'package:ai_parking/data/data_source/building_api.dart';
import 'package:provider/provider.dart';
import 'package:ai_parking/presentation/provider/user_provider.dart';

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
    MyInfoScreen(),
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
    final user = Provider.of<UserProvider>(context).user;
    if (user == null) {
      return const Center(child: Text('유저 정보가 없습니다. 로그인 후 이용해주세요.'));
    }
    final buildingApi = BuildingApi();

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
              user.name,
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
      body: FutureBuilder<BuildingListResponse>(
        future: buildingApi.fetchBuildings(user.address),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('동 정보 불러오기 실패: \\${snapshot.error}'));
          }
          if (snapshot.data!.buildings.isEmpty) {
            return const Center(child: Text('동 정보가 없습니다.'));
          }

          // apartmentId를 유저 데이터에 저장
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final userProvider = Provider.of<UserProvider>(
              context,
              listen: false,
            );
            final newApartmentId = snapshot.data!.apartmentId;
            if (userProvider.user?.apartmentId != newApartmentId) {
              userProvider.setApartmentId(newApartmentId);
            }
          });

          final buildings = snapshot.data!.buildings;
          return ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final b = buildings[index];
              return _ParkingStatusCard(
                dong: b.name,
                available: b.parkingStatus?.availableSpaces ?? 0,
                total: b.parkingStatus?.totalSpaces ?? 0,
                progress: (b.parkingStatus?.totalSpaces ?? 0) == 0
                    ? 0
                    : (b.parkingStatus?.availableSpaces ?? 0) /
                          (b.parkingStatus?.totalSpaces ?? 1),
                buildingId: b.buildingId,
              );
            },
          );
        },
      ),
    );
  }
}

class _ParkingStatusCard extends StatelessWidget {
  final String dong;
  final int available;
  final int total;
  final double progress;
  final String buildingId;

  const _ParkingStatusCard({
    required this.dong,
    required this.available,
    required this.total,
    required this.progress,
    required this.buildingId,
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
              buildingId: buildingId,
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
