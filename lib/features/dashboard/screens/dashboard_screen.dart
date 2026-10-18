import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:midhackathon/core/theme/app_colors.dart';
import 'package:midhackathon/features/dashboard/data/product_data.dart';
import 'package:midhackathon/features/dashboard/models/product.dart';
import 'package:midhackathon/features/dashboard/screens/orders_screen.dart';
import 'package:midhackathon/features/dashboard/screens/shipping_addresses_screen.dart';
import 'package:midhackathon/features/dashboard/screens/success_screen.dart';
import 'package:midhackathon/features/dashboard/widgets/empty_state.dart';
import 'package:midhackathon/features/dashboard/widgets/product_card.dart';
import 'package:midhackathon/features/dashboard/widgets/product_search_delegate.dart';
import 'package:midhackathon/services/auth_services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _tab = 0;
  final Set<Product> _favorites = {};
  final List<Product> _bag = [];
  String _category = 'All';

  List<Product> get _visibleProducts => _category == 'All'
      ? products
      : products.where((item) => item.category == _category).toList();

  void _toggleFavorite(Product product) {
    setState(() {
      _favorites.contains(product)
          ? _favorites.remove(product)
          : _favorites.add(product);
    });
  }

  void _addToBag(Product product) {
    setState(() => _bag.add(product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to your bag'),
        action: SnackBarAction(
          label: 'VIEW BAG',
          onPressed: () => setState(() => _tab = 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [
            _home(),
            _shop(),
            _bagPage(),
            _favoritesPage(),
            _profile(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _home() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _hero()),
        SliverToBoxAdapter(child: _sectionHeader('Sale', 'Super summer sale')),
        _productSliver(products.take(4).toList()),
        SliverToBoxAdapter(
          child: _sectionHeader('New', 'You’ve never seen it before!'),
        ),
        _productSliver(products.skip(2).toList()),
      ],
    );
  }

  Widget _hero() {
    return SizedBox(
      height: 330,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=1200',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
          ),
          const Positioned(
            left: 24,
            bottom: 28,
            child: Text(
              'Street clothes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 18,
            child: Row(
              children: [
                IconButton(
                  onPressed: _searchWithCamera,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: _search,
                  icon: const Icon(Icons.search, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shop() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _pageHeader('Shop', showBack: false)),
        SliverToBoxAdapter(child: _categoryChips()),
        SliverToBoxAdapter(child: _toolbar()),
        _productSliver(_visibleProducts),
      ],
    );
  }

  Widget _favoritesPage() {
    final favoriteProducts = _favorites.toList();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _pageHeader('Favorites', showBack: false)),
        SliverToBoxAdapter(child: _categoryChips()),
        SliverToBoxAdapter(child: _toolbar()),
        if (favoriteProducts.isEmpty)
          const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.favorite_border,
              title: 'Your favorites are empty',
              subtitle: 'Save pieces you love and find them here.',
            ),
          )
        else
          _productSliver(favoriteProducts),
      ],
    );
  }

  Widget _bagPage() {
    final total = _bag.fold<double>(0, (sum, item) => sum + item.price);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _pageHeader('My bag', showBack: false)),
        if (_bag.isEmpty)
          const SliverFillRemaining(
            child: EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your bag is empty',
              subtitle: 'Discover something new in our collection.',
            ),
          )
        else ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _bagItem(_bag[index]),
                childCount: _bag.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: _checkout(total)),
        ],
      ],
    );
  }

  Widget _profile() {
    final user = AuthServices().currentUser;
    final name = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : 'Fashion friend';
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _pageHeader('My profile', showBack: false)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 26),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: Color(0xffffd8d4),
                  child: Icon(Icons.person, size: 42, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      user?.email ?? 'Guest account',
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _profileRow(
              'My orders',
              'Track your recent purchases',
              Icons.receipt_long_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersScreen()),
              ),
            ),
            _profileRow(
              'Shipping addresses',
              'Manage delivery addresses',
              Icons.location_on_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShippingAddressesScreen(),
                ),
              ),
            ),
            _profileRow(
              'Payment methods',
              'Visa •••• 4242',
              Icons.credit_card_outlined,
              () {},
            ),
            _profileRow(
              'Promocodes',
              'You have special promocodes',
              Icons.local_offer_outlined,
              () {},
            ),
            _profileRow(
              'Settings',
              'Notifications, password',
              Icons.settings_outlined,
              () {},
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: OutlinedButton.icon(
                onPressed: () => AuthServices().logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _productSliver(List<Product> items) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.crossAxisExtent > 700 ? 4 : 2;
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(
                product: items[index],
                isFavorite: _favorites.contains(items[index]),
                onFavorite: () => _toggleFavorite(items[index]),
                onTap: () => _showProduct(items[index]),
              ),
              childCount: items.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 14,
              mainAxisSpacing: 24,
              childAspectRatio: .62,
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title, String subtitle) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 28, 20, 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
        TextButton(
          onPressed: () => setState(() => _tab = 1),
          child: const Text('View all'),
        ),
      ],
    ),
  );

  Widget _pageHeader(String title, {required bool showBack}) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
    child: Row(
      children: [
        if (showBack) const BackButton(),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
          ),
        ),
        IconButton(
          onPressed: _searchWithCamera,
          icon: const Icon(Icons.camera_alt_outlined, size: 25),
        ),
        IconButton(
          onPressed: _search,
          icon: const Icon(Icons.search, size: 29),
        ),
      ],
    ),
  );

  Widget _categoryChips() => SizedBox(
    height: 55,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: ['All', 'T-shirts', 'Blouses', 'Dresses', 'Jackets', 'Sweaters']
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ChoiceChip(
                label: Text(item),
                selected: _category == item,
                onSelected: (_) => setState(() => _category = item),
                selectedColor: Colors.black,
                labelStyle: TextStyle(
                  color: _category == item ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Colors.white,
                shape: const StadiumBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );

  Widget _toolbar() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
    child: Row(
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.tune),
          label: const Text('Filters'),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: () => _sort(),
          icon: const Icon(Icons.swap_vert),
          label: const Text('Price: lowest to high'),
        ),
        const Icon(Icons.grid_view, size: 22),
      ],
    ),
  );

  Widget _bottomNavigation() => NavigationBar(
    selectedIndex: _tab,
    onDestinationSelected: (index) => setState(() => _tab = index),
    backgroundColor: Colors.white,
    indicatorColor: Colors.transparent,
    destinations: [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home, color: AppColors.primary),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.shopping_cart_outlined),
        selectedIcon: Icon(Icons.shopping_cart, color: AppColors.primary),
        label: 'Shop',
      ),
      NavigationDestination(
        icon: Badge(
          isLabelVisible: _bag.isNotEmpty,
          label: Text('${_bag.length}'),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
        label: 'Bag',
      ),
      NavigationDestination(
        icon: Badge(
          isLabelVisible: _favorites.isNotEmpty,
          child: const Icon(Icons.favorite_border),
        ),
        label: 'Favorites',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person, color: AppColors.primary),
        label: 'Profile',
      ),
    ],
  );

  Widget _bagItem(Product item) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 0,
    child: ListTile(
      contentPadding: const EdgeInsets.all(8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          item.image,
          width: 70,
          height: 70,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        item.name,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(item.brand),
      trailing: Text(
        '\$${item.price.toStringAsFixed(0)}',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
  );
  Widget _checkout(double total) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              '\$${total.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              setState(() => _bag.clear());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SuccessScreen()),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.all(17),
            ),
            child: const Text('CHECK OUT'),
          ),
        ),
      ],
    ),
  );
  Widget _profileRow(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) => ListTile(
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
    leading: Icon(icon, color: AppColors.primary),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
    ),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.chevron_right),
  );

  void _showProduct(Product product) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              product.image,
              height: 260,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          Text(
            product.brand,
            style: const TextStyle(color: Colors.grey, fontSize: 17),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(sheetContext);
                _addToBag(product);
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.all(16),
              ),
              child: Text('ADD TO BAG • \$${product.price.toStringAsFixed(0)}'),
            ),
          ),
        ],
      ),
    ),
  );
  void _sort() => showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            [
                  'Popular',
                  'Newest',
                  'Customer review',
                  'Price: lowest to high',
                  'Price: highest to low',
                ]
                .map(
                  (item) => ListTile(
                    title: Text(item),
                    onTap: () => Navigator.pop(context),
                  ),
                )
                .toList(),
      ),
    ),
  );
  void _search() =>
      showSearch(context: context, delegate: ProductSearchDelegate(products));

  Future<void> _searchWithCamera() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Photo search'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(bytes, height: 220, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              const Text(
                'Photo captured. Browse styles from our collection that may match your look.',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _search();
              },
              child: const Text('SEARCH STYLES'),
            ),
          ],
        ),
      );
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open camera: ${error.message}')),
      );
    }
  }
}
