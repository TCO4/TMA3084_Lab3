import 'package:flutter/material.dart';

void main() {
  runApp(const PokeCafeApp());
}

const Color cafeCream = Color(0xFFFFF8E8);
const Color cafeYellow = Color(0xFFFFCB45);
const Color cafeRed = Color(0xFFE94B4B);
const Color cafeBrown = Color(0xFF49352A);
const Color cafeGreen = Color(0xFF547B55);

class CafeItem {
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final Color background;
  final String badge;

  const CafeItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.background,
    required this.badge,
  });
}

const List<CafeItem> cafeMenu = [
  CafeItem(
    name: 'Pikachu Latte',
    description: 'Caramel espresso with creamy milk',
    price: 14.00,
    category: 'COFFEE',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
    background: Color(0xFFFFEDB5),
    badge: 'BESTSELLER',
  ),
  CafeItem(
    name: 'Bulbasaur Matcha',
    description: 'Smooth Japanese matcha latte',
    price: 15.00,
    category: 'MATCHA',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    background: Color(0xFFDDEBCF),
    badge: 'POPULAR',
  ),
  CafeItem(
    name: 'Squirtle Blue Soda',
    description: 'Refreshing blue citrus sparkling soda',
    price: 12.00,
    category: 'REFRESHERS',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
    background: Color(0xFFDCEBFA),
    badge: 'REFRESHING',
  ),
  CafeItem(
    name: 'Jigglypuff Frappe',
    description: 'Strawberry cream with fluffy whipped topping',
    price: 16.00,
    category: 'SPECIALS',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/39.png',
    background: Color(0xFFF6DCEB),
    badge: 'SIGNATURE',
  ),
  CafeItem(
    name: 'Eevee Mocha',
    description: 'Rich chocolate mocha with silky milk',
    price: 15.00,
    category: 'COFFEE',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/133.png',
    background: Color(0xFFEBD9C5),
    badge: 'FAN FAVOURITE',
  ),
  CafeItem(
    name: 'Psyduck Lemon Tea',
    description: 'Chilled lemon tea for a sunny day',
    price: 11.00,
    category: 'REFRESHERS',
    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/54.png',
    background: Color(0xFFFFF0BD),
    badge: 'CHILL PICK',
  ),
];

class PokeCafeApp extends StatelessWidget {
  const PokeCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokeCafe',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cafeCream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cafeYellow,
          primary: cafeBrown,
          secondary: cafeRed,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cafeCream,
          foregroundColor: cafeBrown,
          elevation: 0,
          centerTitle: false,
        ),
        fontFamily: 'Roboto',
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Map<String, int> cart = {};
  String selectedCategory = 'ALL';

  int get totalItems =>
      cart.values.fold(0, (total, quantity) => total + quantity);

  double get totalPrice {
    double total = 0;

    for (final item in cafeMenu) {
      total += item.price * (cart[item.name] ?? 0);
    }

    return total;
  }

  List<CafeItem> get visibleItems {
    if (selectedCategory == 'ALL') {
      return cafeMenu;
    }

    return cafeMenu.where((item) => item.category == selectedCategory).toList();
  }

  void addToCart(CafeItem item) {
    setState(() {
      cart[item.name] = (cart[item.name] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to your cart!'),
        duration: const Duration(seconds: 1),
        backgroundColor: cafeGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void changeQuantity(CafeItem item, int change) {
    setState(() {
      final current = cart[item.name] ?? 0;
      final updated = current + change;

      if (updated <= 0) {
        cart.remove(item.name);
      } else {
        cart[item.name] = updated;
      }
    });
  }

  void showCart() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: cafeCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, refreshSheet) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Your Poké Basket',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: cafeBrown,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (cart.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 54,
                                color: cafeBrown,
                              ),
                              SizedBox(height: 12),
                              Text('Your basket is empty!'),
                              Text('Catch a drink to get started.'),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: cafeMenu
                                .where((item) => (cart[item.name] ?? 0) > 0)
                                .map(
                                  (item) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: cafeBrown,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'RM ${item.price.toStringAsFixed(2)} each',
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            changeQuantity(item, -1);
                                            refreshSheet(() {});
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),
                                        Text('${cart[item.name] ?? 0}'),
                                        IconButton(
                                          onPressed: () {
                                            changeQuantity(item, 1);
                                            refreshSheet(() {});
                                          },
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const Divider(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'RM ${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: cafeBrown,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Order summary ready! Demo checkout only.',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.coffee),
                          label: const Text('Place Order'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cafeRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: cafeYellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.catching_pokemon,
                size: 29,
                color: cafeBrown,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'PokeCafe',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 23,
                letterSpacing: -0.7,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: showCart,
                  tooltip: 'View basket',
                  icon: const Icon(Icons.shopping_bag_outlined, size: 28),
                ),
                if (totalItems > 0)
                  Positioned(
                    right: 2,
                    top: 3,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: cafeRed,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$totalItems',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: cafeYellow,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'TRAINER SPECIAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            color: cafeBrown,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'A wild drink appeared!',
                        style: TextStyle(
                          fontSize: 28,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                          color: cafeBrown,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Your next favourite sip awaits.',
                        style: TextStyle(fontSize: 13, color: cafeBrown),
                      ),
                      const SizedBox(height: 14),
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = 'ALL';
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: cafeBrown,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Explore Menu'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png',
                  width: 120,
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: 100,
                      height: 120,
                      child: Icon(
                        Icons.catching_pokemon,
                        size: 90,
                        color: cafeBrown,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Choose Your Treat',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              color: cafeBrown,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Made with a little extra Pokémon magic.',
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['ALL', 'COFFEE', 'MATCHA', 'REFRESHERS', 'SPECIALS']
                  .map((category) {
                    final isSelected = selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          category == 'ALL' ? 'All Drinks' : category,
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        selectedColor: cafeYellow,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: cafeBrown,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        side: BorderSide.none,
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
          const SizedBox(height: 18),
          ...visibleItems.map((item) => buildMenuCard(item)),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                const Icon(Icons.catching_pokemon, color: cafeRed, size: 30),
                const SizedBox(height: 8),
                Text(
                  'GOTTA SIP \'EM ALL!',
                  style: TextStyle(
                    color: cafeBrown.withOpacity(0.8),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Made for trainers, brewed with love.',
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuCard(CafeItem item) {
    final quantity = cart[item.name] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.white,
      elevation: 1.5,
      shadowColor: cafeBrown.withOpacity(0.10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 112,
              decoration: BoxDecoration(
                color: item.background,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.catching_pokemon,
                    size: 55,
                    color: cafeBrown,
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.badge,
                      style: const TextStyle(
                        color: cafeBrown,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: cafeBrown,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RM ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: cafeGreen,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: () => addToCart(item),
              tooltip: 'Add ${item.name}',
              style: IconButton.styleFrom(
                backgroundColor: cafeBrown,
                foregroundColor: Colors.white,
                minimumSize: const Size(38, 38),
              ),
              icon: Icon(quantity > 0 ? Icons.add : Icons.add, size: 23),
            ),
          ],
        ),
      ),
    );
  }
}
