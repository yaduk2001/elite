import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:math';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Timer _colorTimer;
  Color _currentColor = Colors.blue;
  final List<Color> _colorList = [
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.green,
  ];
  int _colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // RGB effect timer
    _colorTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _colorIndex = (_colorIndex + 1) % _colorList.length;
        _currentColor = _colorList[_colorIndex];
      });
    });

    // Start animation
    _colorController.forward();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _colorTimer.cancel();
    super.dispose();
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elite Resort'),
        backgroundColor: _currentColor.withOpacity(0.8),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: _currentColor,
              ),
              child: UserAccountsDrawerHeader(
                accountName: const Text('Guest'),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          (user?.email?[0] ?? '').toUpperCase(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ),
                decoration: BoxDecoration(
                  color: _currentColor,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Bookings'),
              onTap: () {

              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to profile page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Add navigation to settings page
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://placehold.co/600x400/png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      _currentColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerText(
                        text: 'Welcome to Elite Resort',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ShimmerText(
                        text: 'Your perfect getaway destination',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our Amenities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      AmenityCardWidget(
                        icon: Icons.pool,
                        title: 'Swimming Pool',
                      ),
                      AmenityCardWidget(
                        icon: Icons.restaurant,
                        title: 'Restaurant',
                      ),
                      AmenityCardWidget(
                        icon: Icons.spa,
                        title: 'Spa',
                      ),
                      AmenityCardWidget(
                        icon: Icons.fitness_center,
                        title: 'Fitness Center',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const AnimatedOffersSection(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/booking');
              },
              backgroundColor: _currentColor,
              label: const Text('Book Now'),
              icon: const Icon(Icons.book_online),
            ),
          );
        },
      ),
    );
  }
}

class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const ShimmerText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.white,
                Colors.white.withOpacity(0.5),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(
                _shimmerAnimation.value - 1,
                0.0,
              ),
              end: Alignment(
                _shimmerAnimation.value + 1,
                0.0,
              ),
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style,
          ),
        );
      },
    );
  }
}

class AmenityCardWidget extends StatefulWidget {
  final IconData icon;
  final String title;

  const AmenityCardWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  State<AmenityCardWidget> createState() => _AmenityCardWidgetState();
}

class _AmenityCardWidgetState extends State<AmenityCardWidget> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  Color _currentColor = Colors.blue;
  final List<Color> _colorList = [
    Colors.blue,
    Colors.purple,
    Colors.indigo,
    Colors.teal,
  ];
  int _colorIndex = 0;
  late Timer _colorTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _colorTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _colorIndex = (_colorIndex + 1) % _colorList.length;
          _currentColor = _colorList[_colorIndex];
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _colorTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: _currentColor.withOpacity(_isHovered ? 0.3 : 0.1),
                blurRadius: _isHovered ? 15 : 5,
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
            border: Border.all(
              color: _currentColor.withOpacity(_isHovered ? 0.5 : 0.1),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentColor.withOpacity(_isHovered ? 0.1 : 0.05),
                ),
                child: Icon(
                  widget.icon,
                  size: 32,
                  color: _currentColor,
                ),
              ),
              const SizedBox(height: 12),
              ShimmerText(
                text: widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _currentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpecialOffer {
  final String title;
  final String description;
  final String validUntil;
  final IconData icon;
  final Color color;

  SpecialOffer({
    required this.title,
    required this.description,
    required this.validUntil,
    required this.icon,
    required this.color,
  });
}

class AnimatedOffersSection extends StatefulWidget {
  const AnimatedOffersSection({super.key});

  @override
  State<AnimatedOffersSection> createState() => _AnimatedOffersSectionState();
}

class _AnimatedOffersSectionState extends State<AnimatedOffersSection> with SingleTickerProviderStateMixin {
  final List<SpecialOffer> offers = [
    SpecialOffer(
      title: 'Weekend Gateway',
      description: '20% off on weekend stays. Includes breakfast and dinner.',
      validUntil: 'Valid until Dec 31, 2024',
      icon: Icons.weekend,
      color: Colors.blue,
    ),
    SpecialOffer(
      title: 'Spa Package',
      description: 'Complimentary spa session with 3-night stay',
      validUntil: 'Valid until Nov 30, 2024',
      icon: Icons.spa,
      color: Colors.purple,
    ),
    SpecialOffer(
      title: 'Family Package',
      description: 'Kids stay and eat free. Includes access to kids club.',
      validUntil: 'Valid until Oct 15, 2024',
      icon: Icons.family_restroom,
      color: Colors.green,
    ),
    SpecialOffer(
      title: 'Honeymoon Special',
      description: 'Romantic dinner and room decoration included',
      validUntil: 'Valid until Sep 30, 2024',
      icon: Icons.favorite,
      color: Colors.red,
    ),
  ];

  int currentIndex = 0;
  late Timer _timer;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentIndex < offers.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ShimmerText(
            text: 'Special Offers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
                _animationController.reset();
                _animationController.forward();
              });
            },
            itemCount: offers.length,
            itemBuilder: (context, index) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedOfferCard(offer: offers[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            offers.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: currentIndex == index ? 24 : 8,
              decoration: BoxDecoration(
                color: currentIndex == index 
                    ? offers[index].color 
                    : offers[index].color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedOfferCard extends StatefulWidget {
  final SpecialOffer offer;

  const AnimatedOfferCard({
    super.key,
    required this.offer,
  });

  @override
  State<AnimatedOfferCard> createState() => _AnimatedOfferCardState();
}

class _AnimatedOfferCardState extends State<AnimatedOfferCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _controller.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: widget.offer.color.withOpacity(_isHovered ? 0.3 : 0.1),
                  blurRadius: _isHovered ? 15 : 5,
                  spreadRadius: _isHovered ? 2 : 0,
                ),
              ],
              border: Border.all(
                color: widget.offer.color.withOpacity(_isHovered ? 0.5 : 0.1),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        widget.offer.icon,
                        color: widget.offer.color,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.offer.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: widget.offer.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.offer.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  Text(
                    widget.offer.validUntil,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
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