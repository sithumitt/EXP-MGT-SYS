// Purpose: Handles all direct communication with the Supabase database.
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  // --- AUTHENTICATION ---
  // Logs the user in.
  Future<AuthResponse> signIn(String email, String password) {
    return _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Registers a new user.
  Future<AuthResponse> signUp(String email, String password) {
    return _supabase.auth.signUp(email: email, password: password);
  }

  // Logs the user out.
  Future<void> signOut() {
    return _supabase.auth.signOut();
  }

  // --- DATABASE CRUD OPERATIONS ---
  // Adds a new expense to the database.
  Future<void> addRecord(double cash, double expense) {
    return _supabase.from('expense_records').insert({
      'cash_in_hand': cash,
      'expense': expense,
      'user_id': _supabase.auth.currentUser!.id,
    });
  }

  // Updates an existing expense in the database.
  Future<void> updateRecord(String id, double cash, double expense) {
    return _supabase
        .from('expense_records')
        .update({'cash_in_hand': cash, 'expense': expense})
        .eq('id', id);
  }

  // Deletes an expense from the database.
  Future<void> deleteRecord(String id) {
    return _supabase.from('expense_records').delete().eq('id', id);
  }

  // Gets a live stream of expense records from the database.
  Stream<List<Map<String, dynamic>>> getRecordsStream() {
    return _supabase
        .from('expense_records')
        .stream(primaryKey: ['id'])
        .order('created_at');
  }
}
