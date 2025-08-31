import 'dart:io';
import 'dart:convert' as env;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trendz_customer/Models/customer_location_modal.dart';
import 'package:trendz_customer/Models/service_modal.dart';
import 'package:trendz_customer/Models/shop_details_modal.dart';
import 'package:trendz_customer/Pages/App/Home_page.dart';

const securestorage = FlutterSecureStorage();

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://35.169.19.237",
    headers: {"Content-Type": "application/json"},
  ));

  // Future<Map<String, dynamic>> loginWithEmailPassword(
  //     String email, String password) async {
  //   try {
  //     final response = await _dio.post('/api/customer/login', data: {
  //       "email": email,
  //       "password": password,
  //     });
  //     print(response.data['data']);
  //     return response.data;
  //   } catch (e) {
  //     if (e is DioException) {
  //       throw e.response?.data["message"] ?? "Login failed";
  //     }
  //     throw "An unexpected error occurred";
  //   }
  // }

  Future<Map<String, dynamic>> loginWithEmailPassword(
      String email, String password) async {
    try {
      final response = await _dio.post('/api/customer/login', data: {
        "email": email,
        "password": password,
      });

      print(response.data['data']);

      // Store customer_id from login response
      if (response.data['data'] != null &&
          response.data['data']['id'] != null) {
        await securestorage.write(
            key: "customer_id", value: response.data['data']['id'].toString());
        print('Stored customer_id: ${response.data['data']['id']}');
      }

      return response.data;
    } catch (e) {
      if (e is DioException) {
        throw e.response?.data["message"] ?? "Login failed";
      }
      throw "An unexpected error occurred";
    }
  }

  Future<Map<String, dynamic>> createBooking({
  required int shopId,
  required int? barberId, // Keep as optional parameter
  required String bookingDate,
  required int slotId,
  required List<Map<String, dynamic>> services,
  required double totalAmount,
}) async {
  try {
    final token = await securestorage.read(key: "token");
    final customerId = await securestorage.read(key: "customer_id");

    if (customerId == null) {
      throw "Customer ID not found. Please login again.";
    }

    final requestData = {
      "customer_id": int.parse(customerId),
      "shop_id": shopId,
      "slot_id": slotId,
      "booking_date": bookingDate,
      "total_amount": totalAmount,
      "services": services,
    };

    // Only add barber_id if it's not null
    if (barberId != null) {
      requestData["barber_id"] = barberId;
    }

    print('Sending booking request: ${env.json.encode(requestData)}');

    final response = await _dio.post(
      '/api/customer/booking/create',
      data: requestData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    return response.data;
  } on DioException catch (e) {
    print('Dio error: ${e.response?.data}');
    throw e.response?.data["message"] ?? "Booking creation failed";
  } catch (e) {
    throw "An unexpected error occurred: $e";
  }
}

  Future<Map<String, dynamic>> RegisterWithEmailPassword(
    String email,
    int? location_id,
    String name,
    String phone_number,
    String gender,
    String password) async {
  try {
    final response = await _dio.post('/api/customer/register', data: {
      "email": email,
      "password": password,
      "location_id": location_id ?? 1,
      "name": name,
      "gender": gender,
      "phone_number": phone_number
    });
    
    // Store customer_id from registration response
    if (response.data['data'] != null && response.data['data']['id'] != null) {
      await securestorage.write(
        key: "customer_id", 
        value: response.data['data']['id'].toString()
      );
    }
    
    return response.data;
  } catch (e) {
    if (e is DioException) {
      throw e.response?.data["message"] ?? "Registration failed";
    }
    throw "An unexpected error occurred";
  }
}

  Future<List<Services>> fetchServices(int saloon_id) async {
    try {
      final token = await securestorage.read(key: "token");
      final response = await _dio.get(
        '/api/customer/service/$saloon_id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data['data'] as List;
        return data.map((service) => Services.fromJson(service)).toList();
        // print(response.data['data']);
      } else {
        throw Exception(
            'Internal Server Error. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ShopDetails> fetchshopDetails(int shop_id) async {
    try {
      final token = await securestorage.read(key: "token");
      final response = await _dio.get(
        '/api/customer/shop/$shop_id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ShopDetails.fromJson(response.data is String
            ? env.jsonDecode(response.data)
            : response.data['data']);
      } else {
        throw Exception(
            'Internal Server Error. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<CustomerLocation> fetchlocation() async {
    try {
      final response = await _dio.get(
        '/api/customer/get-location',
      );

      if (response.statusCode == 200) {
        // print(response.data['data']);
        return CustomerLocation.fromJson(response.data);
      } else {
        throw Exception(
            'Internal Server Error. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Future<CustomerLocation> fetchTimeSlot() async {
  //   try {
  //     final token = await securestorage.read(key: "token");
  //     final response = await _dio.get(
  //       '/api/customer/slot/1',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       print('fetchTimeSlot full response:');
  //       print(response.data);
  //       // You should return a CustomerLocation here, update as needed:
  //       return CustomerLocation.fromJson(response.data);
  //     } else {
  //       throw Exception(
  //           'Internal Server Error. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Error: $e');
  //   }
  // }

  Future<List<dynamic>> fetchTimeSlot() async {
    try {
      final token = await securestorage.read(key: "token");
      final response = await _dio.get(
        '/api/customer/slot/1',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Assuming the API returns the slots array directly in 'data'
        return response.data['data'] as List<dynamic>;
      } else {
        throw Exception('Failed to load time slots');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // In this method, we fetch the list of barbers from the API.
  // Future<List<Map<String, dynamic>>> fetchBarbers() async {
  //   try {
  //     final token = await securestorage.read(key: "token");
  //     final response = await _dio.get(
  //       '/api/merchant/customers',
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       // Assuming the API returns an array of barbers
  //       // You may need to adjust this based on your actual API response structure
  //       List<dynamic> data = response.data['data'];
  //       return data
  //           .map((barber) => {
  //                 'name': barber['name'] ?? 'No Name',
  //                 'profile': barber['profile_image'] ??
  //                     'assets/images/default_barber.png',
  //                 'experience': barber['experience']?.toString() ?? '0 years',
  //                 'specialty': barber['specialty'] ?? 'General Barbering'
  //               })
  //           .toList();
  //     } else {
  //       throw Exception('Failed to load barbers');
  //     }
  //   } catch (e) {
  //     throw Exception('Error fetching barbers: $e');
  //   }
  // }

  // In api_services.dart, we can add a method to fetch a specific shop with its barbers.
  Future<Map<String, dynamic>> fetchShopWithBarbers(int shopId) async {
    try {
      final token = await securestorage.read(key: "token");
      final response = await _dio.get(
        '/api/customer/shop/$shopId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response
            .data['data']; // Return the data part which contains barbers
      } else {
        throw Exception('Failed to load shop with barbers');
      }
    } catch (e) {
      throw Exception('Error fetching shop with barbers: $e');
    }
  }

  //-----------Manage Bookings--------------------
Future<List<dynamic>> fetchPendingBookings() async {
  try {
    final token = await securestorage.read(key: "token");
    final response = await _dio.get(
      '/api/customer/booking/pending',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load pending bookings');
    }
  } catch (e) {
    throw Exception('Error fetching pending bookings: $e');
  }
}

Future<List<dynamic>> fetchCancelledBookings() async {
  try {
    final token = await securestorage.read(key: "token");
    final response = await _dio.get(
      '/api/customer/booking/cancelled',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load cancelled bookings');
    }
  } catch (e) {
    throw Exception('Error fetching cancelled bookings: $e');
  }
}

Future<List<dynamic>> fetchCompletedBookings() async {
  try {
    final token = await securestorage.read(key: "token");
    final response = await _dio.get(
      '/api/customer/booking/completed',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data['data'] as List<dynamic>;
    } else {
      throw Exception('Failed to load completed bookings');
    }
  } catch (e) {
    throw Exception('Error fetching completed bookings: $e');
  }
}

// cancelBooking method
Future<Map<String, dynamic>> cancelBooking(int bookingId, String reason) async {
  try {
    final token = await securestorage.read(key: "token");
    final response = await _dio.patch(
      '/api/customer/booking/$bookingId/cancel',
      data: {
        "cancellation_reason": reason,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    return response.data;
  } on DioException catch (e) {
    print('Cancel booking error: ${e.response?.data}');
    throw e.response?.data["message"] ?? "Booking cancellation failed";
  } catch (e) {
    throw "An unexpected error occurred: $e";
  }
}


}
