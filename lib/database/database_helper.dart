import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/wound_assessment.dart';
import '../models/user_profile.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('healplus.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabela de perfil do usuário
    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        specialty TEXT,
        crm_coren TEXT,
        profile_image_path TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tabela de avaliações de feridas
    await db.execute('''
      CREATE TABLE wound_assessments (
        id TEXT PRIMARY KEY,
        patient_name TEXT NOT NULL,
        birth_date TEXT,
        phone TEXT,
        email TEXT,
        profession TEXT,
        marital_status TEXT,
        wound_image_path TEXT,
        width REAL,
        length REAL,
        depth REAL,
        location TEXT,
        location_coordinates TEXT,
        evolution_time TEXT,
        etiology TEXT,
        pressure_injury INTEGER,
        granulation_percent REAL,
        epithelialization_percent REAL,
        eschar_percent REAL,
        dry_necrosis_percent REAL,
        pain_intensity INTEGER,
        pain_relief_factors TEXT,
        pain_worsening_factors TEXT,
        inflammation_rubor INTEGER,
        inflammation_calor INTEGER,
        inflammation_edema INTEGER,
        inflammation_pain INTEGER,
        inflammation_function_loss INTEGER,
        infection_erythema INTEGER,
        infection_calor INTEGER,
        infection_edema INTEGER,
        infection_pain INTEGER,
        infection_purulent_exudate INTEGER,
        infection_fetid_odor INTEGER,
        infection_healing_delay INTEGER,
        culture_performed INTEGER,
        exudate_quantity TEXT,
        exudate_type TEXT,
        exudate_consistency TEXT,
        edge_characteristics TEXT,
        edge_attachment TEXT,
        edge_detached INTEGER,
        healing_velocity TEXT,
        tunnels_present INTEGER,
        tunnel_location TEXT,
        perilesional_skin_moisture TEXT,
        skin_alteration_extent TEXT,
        skin_condition TEXT,
        observations TEXT,
        treatment_plan TEXT,
        consultation_date TEXT,
        consultation_time TEXT,
        professional_name TEXT,
        professional_coren_crm TEXT,
        return_date TEXT,
        activity_level TEXT,
        understanding_adherence TEXT,
        social_support TEXT,
        physical_activity INTEGER,
        alcohol_consumption INTEGER,
        smoker INTEGER,
        nutritional_assessment TEXT,
        water_intake REAL,
        treatment_objective TEXT,
        healing_history TEXT,
        has_allergy INTEGER,
        allergies TEXT,
        surgeries_performed INTEGER,
        surgeries_details TEXT,
        claudication INTEGER,
        rest_pain INTEGER,
        peripheral_pulses TEXT,
        comorbidities TEXT,
        medications TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tabela de timers
    await db.execute('''
      CREATE TABLE assessment_timers (
        id TEXT PRIMARY KEY,
        wound_assessment_id TEXT NOT NULL,
        timer_name TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        duration_seconds INTEGER,
        is_active INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (wound_assessment_id) REFERENCES wound_assessments(id)
      )
    ''');
  }

  // Métodos para User Profile
  Future<int> insertUserProfile(UserProfile profile) async {
    final db = await database;
    return await db.insert('user_profile', profile.toMap());
  }

  Future<UserProfile?> getUserProfile() async {
    final db = await database;
    final maps = await db.query('user_profile', limit: 1);
    if (maps.isEmpty) return null;
    return UserProfile.fromMap(maps.first);
  }

  Future<int> updateUserProfile(UserProfile profile) async {
    final db = await database;
    return await db.update(
      'user_profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // Métodos para Wound Assessments
  Future<String> insertWoundAssessment(WoundAssessment assessment) async {
    final db = await database;
    await db.insert('wound_assessments', assessment.toMap());
    return assessment.id;
  }

  Future<List<WoundAssessment>> getAllWoundAssessments() async {
    final db = await database;
    final maps = await db.query('wound_assessments', orderBy: 'created_at DESC');
    return maps.map((map) => WoundAssessment.fromMap(map)).toList();
  }

  Future<WoundAssessment?> getWoundAssessment(String id) async {
    final db = await database;
    final maps = await db.query(
      'wound_assessments',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return WoundAssessment.fromMap(maps.first);
  }

  Future<int> updateWoundAssessment(WoundAssessment assessment) async {
    final db = await database;
    return await db.update(
      'wound_assessments',
      assessment.toMap(),
      where: 'id = ?',
      whereArgs: [assessment.id],
    );
  }

  Future<int> deleteWoundAssessment(String id) async {
    final db = await database;
    return await db.delete(
      'wound_assessments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para Timers
  Future<String> insertTimer(AssessmentTimer timer) async {
    final db = await database;
    await db.insert('assessment_timers', timer.toMap());
    return timer.id;
  }

  Future<List<AssessmentTimer>> getTimersForAssessment(String assessmentId) async {
    final db = await database;
    final maps = await db.query(
      'assessment_timers',
      where: 'wound_assessment_id = ?',
      whereArgs: [assessmentId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => AssessmentTimer.fromMap(map)).toList();
  }

  Future<int> updateTimer(AssessmentTimer timer) async {
    final db = await database;
    return await db.update(
      'assessment_timers',
      timer.toMap(),
      where: 'id = ?',
      whereArgs: [timer.id],
    );
  }

  Future<int> deleteTimer(String id) async {
    final db = await database;
    return await db.delete(
      'assessment_timers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

