import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/userresponse_model.dart';

class FirebaseUserManager {
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  /// ✅ CREATE: Add or update a single user
  Future<void> addOrUpdateUser(UserResponseModel user) async {
    try {
      await usersCollection.doc(user.id.toString()).set(user.toJson());
      print("✅ User ${user.id} added/updated successfully.");
    } catch (e) {
      print("❌ Error adding/updating user ${user.id}: $e");
      throw Exception("Failed to add/update user ${user.id}");
    }
  }

  /// ✅ CREATE: Add or update a list of users
  Future<void> uploadUsers(List<UserResponseModel> users) async {
    try {
      for (var user in users) {

        final docSnapshot = await usersCollection.doc(user.id.toString()).get();

        if (docSnapshot.exists) {
          print('User with ID ${user.id} already exists. Skipping upload.');
          return; // Stop here if user already exists
        }
        else{
          await usersCollection.doc(user.id.toString()).set(user.toJson());
        }
      }
      print("✅ All users uploaded successfully.");
    } catch (e) {
      print("❌ Error uploading users: $e");
      throw Exception("Failed to upload user list");
    }
  }

  /// ✅ READ: Get all users
  Future<List<UserResponseModel>> getAllUsers() async {
    try {
      final snapshot = await usersCollection.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserResponseModel.fromJson(data);
      }).toList();
    } catch (e) {
      print("❌ Error fetching all users: $e");
      throw Exception("Failed to fetch users");
    }
  }

  /// ✅ READ: Get user by ID
  Future<UserResponseModel?> getUserById(int id) async {
    try {
      final doc = await usersCollection.doc(id.toString()).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserResponseModel.fromJson(data);
      } else {
        print("⚠️ User with ID $id not found.");
        return null;
      }
    } catch (e) {
      print("❌ Error fetching user $id: $e");
      throw Exception("Failed to fetch user $id");
    }
  }

  /// 🔄 UPDATE: Update a user's data
  Future<void> updateUser(UserResponseModel user) async {
    try {
      await usersCollection.doc(user.id.toString()).update(user.toJson());
      print("✅ User ${user.id} updated successfully.");
    } catch (e) {
      print("❌ Error updating user ${user.id}: $e");
      throw Exception("Failed to update user ${user.id}");
    }
  }

  /// ❌ DELETE: Delete a user by ID
  Future<void> deleteUser(int id) async {
    try {
      await usersCollection.doc(id.toString()).delete();
      print("✅ User $id deleted successfully.");
    } catch (e) {
      print("❌ Error deleting user $id: $e");
      throw Exception("Failed to delete user $id");
    }
  }

  /// ❌ DELETE ALL USERS
  Future<void> deleteAllUsers() async {
    try {
      final snapshot = await usersCollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print("✅ All users deleted successfully.");
    } catch (e) {
      print("❌ Error deleting all users: $e");
      throw Exception("Failed to delete all users");
    }
  }
}
