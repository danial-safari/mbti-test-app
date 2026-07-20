import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';

/// Detail screen showing information about a specific MBTI personality type.
/// Demonstrates: TabController with TabBar, dynamic data display based on arguments.
class PersonalityDetailScreen extends StatefulWidget {
  final String typeCode;

  const PersonalityDetailScreen({super.key, required this.typeCode});

  @override
  State<PersonalityDetailScreen> createState() =>
      _PersonalityDetailScreenState();
}

class _PersonalityDetailScreenState extends State<PersonalityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Hardcoded personality data for demonstration
  static const Map<String, Map<String, dynamic>> _typeData = {
    'INTJ': {
      'title': 'معمار',
      'strengths': ['مستقل', 'استراتژیک', 'آینده‌نگر', 'تحلیلی'],
      'weaknesses': ['کمال‌گرا', 'سرد', 'منتقد'],
      'careers': ['مهندس نرم‌افزار', 'دانشمند', 'استراتژیست'],
      'famous': ['ایلان ماسک', 'استیون هاوکینگ'],
    },
    'INTP': {
      'title': 'منطق‌دان',
      'strengths': ['خلاق', 'ذهن‌باز', 'تحلیلی', 'دقیق'],
      'weaknesses': ['منزوی', 'بی‌تمرکز', 'بی‌صبر'],
      'careers': ['برنامه‌نویس', 'ریاضیدان', 'فیلسوف'],
      'famous': ['آلبرت انیشتین', 'بیل گیتس'],
    },
    'ENTJ': {
      'title': 'فرمانده',
      'strengths': ['قاطع', 'جسور', 'منظم', 'کاریزماتیک'],
      'weaknesses': ['کنترل‌کننده', 'بی‌صبر', 'سرد'],
      'careers': ['مدیرعامل', 'وکیل', 'مشاور'],
      'famous': ['استیو جابز', 'مارگارت تاچر'],
    },
    'ENTP': {
      'title': 'مناظره‌کننده',
      'strengths': ['جسور', 'خلاق', 'اجتماعی', 'زیرک'],
      'weaknesses': ['بی‌تمرکز', 'تهوری', 'بی‌صبر'],
      'careers': ['کارآفرین', 'وکیل', 'روزنامه‌نگار'],
      'famous': ['مارک تواین', 'تام هنکس'],
    },
    'INFJ': {
      'title': 'حامی',
      'strengths': ['بصیر', 'دیپلماتیک', 'خلاق', 'پرشور'],
      'weaknesses': ['حساس', 'ایده‌آلیست', 'منزوی'],
      'careers': ['مشاور', 'نویسنده', 'روانشناس'],
      'famous': ['مارتین لوتر کینگ', 'نلسون ماندلا'],
    },
    'INFP': {
      'title': 'میانجی',
      'strengths': ['خلاق', 'وفادار', 'حساس', 'آرمان‌گرا'],
      'weaknesses': ['ایده‌آلیست', 'منزوی', 'حساس به انتقاد'],
      'careers': ['نویسنده', 'هنرمند', 'مشاور'],
      'famous': ['ویلیام شکسپیر', 'جی.آر.آر. تالکین'],
    },
    'ENFJ': {
      'title': 'قهرمان',
      'strengths': ['جذاب', 'الهام‌بخش', 'قابل اعتماد', 'اجتماعی'],
      'weaknesses': ['خوشایند مردم', 'ایده‌آلیست', 'حساس'],
      'careers': ['معلم', 'رهبر', 'مشاور'],
      'famous': ['اپرا وینفری', 'باراک اوباما'],
    },
    'ENFP': {
      'title': 'مبارز',
      'strengths': ['مشتاق', 'خلاق', 'اجتماعی', 'خوش‌بین'],
      'weaknesses': ['بی‌تمرکز', 'حساس', 'پراکنده'],
      'careers': 'هنرمند، روزنامه‌نگار، مشاور',
      'famous': ['رابین ویلیامز', 'والت دیزنی'],
    },
    'ISTJ': {
      'title': 'لجستیک‌دان',
      'strengths': ['مسئول', 'منظم', 'قاطع', 'وفادار'],
      'weaknesses': ['لجباز', 'غیرقابل انعطاف', 'سرد'],
      'careers': ['حسابدار', 'مدیر', 'نظامی'],
      'famous': ['جورج واشنگتن', 'آنگلا مرکل'],
    },
    'ISFJ': {
      'title': 'مدافع',
      'strengths': ['وفادار', 'گرم', 'مسئول', 'حساس'],
      'weaknesses': ['خوشایند مردم', 'محافظه‌کار', 'حساس'],
      'careers': ['پرستار', 'معلم', 'منشی'],
      'famous': ['ملکه الیزابت دوم', 'بیانسه'],
    },
    'ESTJ': {
      'title': 'مدیر اجرایی',
      'strengths': ['منظم', 'قاطع', 'قابل اعتماد', 'سخت‌کوش'],
      'weaknesses': ['کنترل‌کننده', 'لجباز', 'بی‌صبر'],
      'careers': ['مدیر', 'قاضی', 'افسر نظامی'],
      'famous': ['هنری فورد', 'هیلاری کلینتون'],
    },
    'ESFJ': {
      'title': 'مراقب',
      'strengths': ['اجتماعی', 'گرم', 'مسئول', 'همکار'],
      'weaknesses': ['خوشایند مردم', 'حساس', 'محافظه‌کار'],
      'careers': ['معلم', 'پرستار', 'فروشنده'],
      'famous': ['تیلور سوئیفت', 'بیل کازبی'],
    },
    'ISTP': {
      'title': 'استادکار',
      'strengths': ['عملی', 'انعطاف‌پذیر', 'آرام', 'تحلیلی'],
      'weaknesses': ['منزوی', 'بی‌قرار', 'ریسک‌پذیر'],
      'careers': ['مهندس', 'تکنسین', 'خلبان'],
      'famous': ['بروس لی', 'مایکل جردن'],
    },
    'ISFP': {
      'title': 'ماجراجو',
      'strengths': ['حساس', 'هنرمند', 'آرام', 'وفادار'],
      'weaknesses': ['حساس به انتقاد', 'اجتنابی', 'منزوی'],
      'careers': ['هنرمند', 'طراح', 'دامپزشک'],
      'famous': ['مایکل جکسون', 'فریدا کالو'],
    },
    'ESTP': {
      'title': 'کارآفرین',
      'strengths': ['پرانرژی', 'عملی', 'اجتماعی', 'جسور'],
      'weaknesses': ['بی‌صبر', 'ریسک‌پذیر', 'بی‌تمرکز'],
      'careers': ['کارآفرین', 'ورزشکار', 'مأمور پلیس'],
      'famous': ['دونالد ترامپ', 'مدونا'],
    },
    'ESFP': {
      'title': 'سرگرم‌کننده',
      'strengths': ['مشتاق', 'اجتماعی', 'خلاق', 'خوش‌بین'],
      'weaknesses': ['بی‌تمرکز', 'حساس', 'بی‌قرار'],
      'careers': ['هنرمند', 'بازیگر', 'فروشنده'],
      'famous': ['مریلین مونرو', 'الویس پریسلی'],
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _typeData[widget.typeCode];
    final typeColor = getTypeColor(widget.typeCode);

    if (data == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.typeCode)),
        body: const Center(child: Text('اطلاعاتی یافت نشد')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero header ──
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [typeColor, typeColor.withValues(alpha: 0.7)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        widget.typeCode,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Tab Bar ──
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: typeColor,
                indicatorColor: typeColor,
                tabs: const [
                  Tab(text: 'نقاط قوت'),
                  Tab(text: 'نقاط ضعف'),
                  Tab(text: 'پیشنهادات شغلی'),
                  Tab(text: 'افراد مشهور'),
                ],
              ),
            ),
          ),

          // ── Tab Content ──
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(
                  (data['strengths'] as List<String>),
                  Icons.star_outline,
                  typeColor,
                ),
                _buildList(
                  (data['weaknesses'] as List<String>),
                  Icons.warning_amber_outlined,
                  Colors.red,
                ),
                _buildList(
                  _toList(data['careers']),
                  Icons.work_outline,
                  Colors.green,
                ),
                _buildList(
                  _toList(data['famous']),
                  Icons.person_outline,
                  Colors.amber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Converts value to List<String>
  List<String> _toList(dynamic value) {
    if (value is List) return value.cast<String>();
    if (value is String) return [value];
    return [];
  }

  /// Builds a simple list of items with icons
  Widget _buildList(List<String> items, IconData icon, Color color) {
    if (items.isEmpty) {
      return const Center(child: Text('اطلاعاتی موجود نیست'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withValues(alpha: 0.2)),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            title: Text(items[index]),
          ),
        )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: index * 100),
              duration: 400.ms,
            )
            .slideX(begin: 0.05);
      },
    );
  }
}

/// Helper delegate for the sticky tab bar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}