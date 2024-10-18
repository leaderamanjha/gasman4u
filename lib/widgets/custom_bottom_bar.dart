import 'package:flutter/material.dart';

enum BottomBarEnum {
  home,
  order,
  wallet,
  cart,
  profile,
}

class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({
    super.key,
    required this.selectedIndex,
    this.onChanged,
  });

  final int selectedIndex;
  final Function(BottomBarEnum)? onChanged;

  final List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: Icon(Icons.local_gas_station_outlined, color: Colors.white),
      activeIcon:
          Icon(Icons.local_gas_station_outlined, color: Colors.orange.shade700),
      title: "Home",
      type: BottomBarEnum.home,
    ),
    BottomMenuModel(
      icon: Icon(Icons.card_giftcard, color: Colors.white),
      activeIcon: Icon(Icons.card_giftcard, color: Colors.orange.shade700),
      title: "Orders",
      type: BottomBarEnum.order,
    ),
    BottomMenuModel(
      icon: Icon(Icons.wallet_rounded, color: Colors.white),
      activeIcon: Icon(Icons.wallet_rounded, color: Colors.orange.shade700),
      title: "Wallet",
      type: BottomBarEnum.wallet,
    ),
    BottomMenuModel(
      icon: Icon(Icons.shopping_cart_rounded, color: Colors.white),
      activeIcon:
          Icon(Icons.shopping_cart_rounded, color: Colors.orange.shade700),
      title: "Cart",
      type: BottomBarEnum.cart,
    ),
    BottomMenuModel(
      icon: Icon(Icons.person_2_rounded, color: Colors.white),
      activeIcon: Icon(Icons.person_2_rounded, color: Colors.orange.shade700),
      title: "Profile",
      type: BottomBarEnum.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.blue.shade900,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bottomMenuList[index].icon,
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(bottomMenuList[index].title ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      )),
                ),
              ],
            ),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bottomMenuList[index].activeIcon,
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.orange.shade700,
                        ),
                  ),
                ),
              ],
            ),
            label: '',
          );
        }),
        onTap: (index) {
          onChanged?.call(bottomMenuList[index].type);
        },
      ),
    );
  }
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });

  final Widget icon;
  final Widget activeIcon;
  final String? title;
  final BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffffff),
      padding: const EdgeInsets.all(10),
      child: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
