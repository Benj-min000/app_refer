import 'package:flutter/material.dart';

class Restaurant {
  final String imageUrl;
  final String name;
  final List<String> tags;
  final double rating;
  final String discount;
  final String deliveryTime;
  final String distanceTo;
  final String displayPrice;

  Restaurant(
    {required this.imageUrl,
      required this.name,
      this.tags = const [],
      required this.rating,
      required this.discount,
      required this.deliveryTime,
      required this.distanceTo,
      required this.displayPrice,
    });
}

int restaurantsListLength() {
  return restaurantsListData.length;
}

List<Restaurant> getRestaurantsList(int index) {
  if (index >= 0 && index < restaurantsListData.length) {
    return restaurantsListData[index];
  }
  return [];
}

List<List<Restaurant>> restaurantsListData = [
  [
    Restaurant(
        imageUrl: 'assets/images/restaurant_1.jpeg',
        name: 'Texas Cafe',
        tags: ['South Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/restaurant_2.jpeg',
        name: 'Texas Cafe',
        tags: ['South Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/restaurant_3.jpeg',
        name: 'Texas Cafe',
        tags: ['South Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/restaurant_4.jpeg',
        name: 'Texas Cafe',
        tags: ['South Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/restaurant_5.jpeg',
        name: 'Texas Cafe',
        tags: ['South Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
  ],
  [
    Restaurant(
        imageUrl: 'assets/images/veg10.jpeg',
        name: 'Naivedyam By Moti Mahal',
        tags: ['Pure Veg', 'North Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/veg9.jpeg',
        name: 'Naivedyam By Moti Mahal',
        tags: ['Pure Veg', 'North Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/veg8.jpeg',
        name: 'Naivedyam By Moti Mahal',
        tags: ['Pure Veg', 'North Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/veg7.jpeg',
        name: 'Naivedyam By Moti Mahal',
        tags: ['Pure Veg', 'North Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/veg6.jpeg',
        name: 'Naivedyam By Moti Mahal',
        tags: ['Pure Veg', 'North Indian', 'Chinese'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
  ],
  [
    Restaurant(
        imageUrl: 'assets/images/cake1.jpeg',
        name: 'Baked With Love',
        tags: ['Cakes', 'Pastries'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/cake2.jpeg',
        name: 'Baked With Love',
        tags: ['Cakes', 'Pastries'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/cake3.jpeg',
        name: 'Baked With Love',
        tags: ['Cakes', 'Pastries'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/cake4.jpeg',
        name: 'Baked With Love',
        tags: ['Cakes', 'Pastries'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/cake5.jpeg',
        name: 'Baked With Love',
        tags: ['Cakes', 'Pastries'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
  ],
  [
    Restaurant(
        imageUrl: 'assets/images/gulabjamun.jpeg',
        name: 'Bikaner Express',
        tags: ['Sweets', 'Snacks'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/jalebi.webp',
        name: 'Bikaner Express',
        tags: ['Sweets', 'Snacks'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/kajubarfi.jpeg',
        name: 'Bikaner Express',
        tags: ['Sweets', 'Snacks'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/laddoo.jpeg',
        name: 'Bikaner Express',
        tags: ['Sweets', 'Snacks'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/veg6.jpeg',
        name: 'Bikaner Express',
        tags: ['Sweets', 'Snacks'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
  ],
  [
    Restaurant(
        imageUrl: 'assets/images/burger1.jpeg',
        name: 'MC Donald',
        tags: ['Pure Veg', 'Fast Food'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/burger2.jpeg',
        name: 'MC Donald',
        tags: ['Pure Veg'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/burger3.jpeg',
        name: 'MC Donald',
        tags: ['Pure Veg'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/burger4.jpeg',
        name: 'MC Donald',
        tags: ['Pure Veg'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
    Restaurant(
        imageUrl: 'assets/images/burger6.jpeg',
        name: 'MC Donald',
        tags: ['Pure Veg'],
        rating: 4.0,
        discount: '40% off up to Rs.100',
        deliveryTime: '40-50 min',
        distanceTo: '10 km',
        displayPrice: 'Rs 250 for one'),
  ],
];
