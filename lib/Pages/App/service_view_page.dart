import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trendz_customer/Components/elevated_button.dart';
import 'package:trendz_customer/Pages/App/cart_page.dart';

class DetailsPage extends StatefulWidget {
  final String tag;
  final String serviceName;
  final String price;
  final String imageurl;

  const DetailsPage({
    Key? key,
    required this.tag,
    required this.serviceName,
    required this.price,
    required this.imageurl,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Content area
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Image and Carousel
                  Stack(
                    children: [
                      Hero(
                        tag: widget.tag,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(widget.imageurl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Share functionality
                          },
                          icon: const Icon(
                            Iconsax.share,
                            size: 16,
                          ),
                          label: Text("Share",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Service Name and Price
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.serviceName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.price}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),

                  const SizedBox(height: 20),
                  // Features Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Features:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const FeatureList(),
                  const SizedBox(height: 20),
                  // Gallery Slider
                  const GallerySlider(),
                  const SizedBox(height: 20),
                  // Reviews Section
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "User Reviews:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const ReviewSection(),
                  const SizedBox(height: 20),
                  // Related Services
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "You may also like:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const RelatedServices(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            // Back and Like Button
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {
                    // Like functionality
                  },
                ),
              ),
            ),
            // Bottom Add to Cart Button
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: CustomElevatedButton(
                      paddingVertical: 14,
                      text: "Add to cart",
                      icon: Iconsax.shopping_cart,
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartPage(
                                          selectedDate: "12/10/2024",
                                          selectedLocation: "Maruthamunai",
                                        )))
                          }),
                )),
          ],
        ),
      ),
    );
  }
}

// Sample Widgets
class FeatureList extends StatelessWidget {
  const FeatureList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text("Affordable Pricing"),
            ],
          ),
          SizedBox(height: 8), // Control spacing here
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text("24/7 Support Available"),
            ],
          ),
        ],
      ),
    );
  }
}

class GallerySlider extends StatelessWidget {
  const GallerySlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Gallary",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
          items: [
            "https://dummyimage.com/1280x720/fff/aaa",
            "https://dummyimage.com/1280x720/fff/aaa",
            "https://dummyimage.com/1280x720/fff/aaa",
          ].map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ReviewSection extends StatelessWidget {
  const ReviewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ReviewCard(
          name: "John Doe",
          comment: "Excellent service!",
          rating: 4.5,
        ),
        ReviewCard(
          name: "Jane Smith",
          comment: "Would highly recommend!",
          rating: 5.0,
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String comment;
  final double rating;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.comment,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24.0,
                  backgroundColor: Colors.grey.shade200,
                  child:
                      const Icon(Icons.person, color: Colors.black, size: 28.0),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < rating.floor()
                                ? Icons.star
                                : index < rating
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.amber,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              comment,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 14.0,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RelatedServices extends StatelessWidget {
  const RelatedServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const RelatedServiceCard(
            imageUrl: "https://dummyimage.com/1280x720/fff/aaa",
            title: "Service A",
            price: "\$200",
          ),
          const RelatedServiceCard(
            imageUrl: "https://dummyimage.com/1280x720/fff/aaa",
            title: "Service B",
            price: "\$300",
          ),
          const RelatedServiceCard(
            imageUrl: "https://dummyimage.com/1280x720/fff/aaa",
            title: "Service C",
            price: "\$400",
          ),
        ],
      ),
    );
  }
}

class RelatedServiceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const RelatedServiceCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      elevation: 5.0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(price, style: const TextStyle(color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
