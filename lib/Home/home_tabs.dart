import 'package:flutter/material.dart';
import 'package:user_app/extensions/context_translate_ext.dart';

class HomeCategoryItem {
  final IconData icon;
  final String label;
  HomeCategoryItem({required this.icon, required this.label});
}

class HomeTab {
  final String label;
  final List<HomeCategoryItem> categories;
  
  HomeTab({required this.label, required this.categories});
}

List<HomeTab> getHomeTabs(BuildContext context) {
  final t = context.t;
  return [
    // Food Delivery Tab
    HomeTab(
      label: t.tabFoodDelivery,
      categories: [
        HomeCategoryItem(icon: Icons.percent, label: t.categoryDiscounts),
        HomeCategoryItem(icon: Icons.kebab_dining, label: t.categoryPork),
        HomeCategoryItem(icon: Icons.set_meal, label: t.categoryTonkatsuSashimi),
        HomeCategoryItem(icon: Icons.local_pizza, label: t.categoryPizza),
        HomeCategoryItem(icon: Icons.soup_kitchen, label: t.categoryStew),
        HomeCategoryItem(icon: Icons.restaurant, label: t.categoryChinese),
        HomeCategoryItem(icon: Icons.lunch_dining, label: t.categoryChicken),
        HomeCategoryItem(icon: Icons.rice_bowl, label: t.categoryKorean),
        HomeCategoryItem(icon: Icons.ramen_dining, label: t.categoryOneBowl),
        HomeCategoryItem(icon: Icons.rice_bowl, label: t.categoryKorean),
        HomeCategoryItem(icon: Icons.ramen_dining, label: t.categoryOneBowl),
      ],
    ),
    
    // Pickup Tab
    HomeTab(
      label: t.tabPickup,
      categories: [
        HomeCategoryItem(icon: Icons.percent_outlined, label: t.categoryPichupDiscount),
        HomeCategoryItem(icon: Icons.fastfood, label: t.categoryFastFood),
        HomeCategoryItem(icon: Icons.coffee, label: t.categoryCoffee),
        HomeCategoryItem(icon: Icons.bakery_dining, label: t.categoryBakery),
        HomeCategoryItem(icon: Icons.local_pizza, label: t.categoryPizza),
        HomeCategoryItem(icon: Icons.lunch_dining, label: t.categoryLunch),
      ],
    ),
    
    // Grocery Shopping Tab
    HomeTab(
      label: t.tabGroceryShopping,
      categories: [
        HomeCategoryItem(icon: Icons.shopping_basket, label: t.categoryFreshProduce),
        HomeCategoryItem(icon: Icons.egg, label: t.categoryDairyEggs),
        HomeCategoryItem(icon: Icons.set_meal, label: t.categoryMeat),
        HomeCategoryItem(icon: Icons.water_drop, label: t.categoryBeverages),
        HomeCategoryItem(icon: Icons.bakery_dining, label: t.categoryBakery),
        HomeCategoryItem(icon: Icons.icecream, label: t.categoryFrozen),
        HomeCategoryItem(icon: Icons.local_dining, label: t.categorySnacks),
        HomeCategoryItem(icon: Icons.cleaning_services, label: t.categoryHousehold),
      ],
    ),
    
    // Gifting Tab
    HomeTab(
      label: t.tabGifting,
      categories: [
        HomeCategoryItem(icon: Icons.cake, label: t.categoryCakes),
        HomeCategoryItem(icon: Icons.local_florist, label: t.categoryFlowers),
        HomeCategoryItem(icon: Icons.card_giftcard, label: t.categoryGiftBoxes),
        HomeCategoryItem(icon: Icons.celebration, label: t.categoryPartySupplies),
        HomeCategoryItem(icon: Icons.redeem, label: t.categoryGiftCards),
        HomeCategoryItem(icon: Icons.favorite, label: t.categorySpecialOccasions),
      ],
    ),
    
    // Benefits Tab
    HomeTab(
      label: t.tabBenefits,
      categories: [
        HomeCategoryItem(icon: Icons.local_offer, label: t.categoryDailyDeals),
        HomeCategoryItem(icon: Icons.stars, label: t.categoryLoyaltyRewards),
        HomeCategoryItem(icon: Icons.discount, label: t.categoryCoupons),
        HomeCategoryItem(icon: Icons.new_releases, label: t.categoryNewOffers),
        HomeCategoryItem(icon: Icons.workspace_premium, label: t.categoryExclusiveDeals),
      ],
    ),
  ];
}
