import 'dart:convert';
import 'package:uuid/uuid.dart';

class WoundAssessment {
  final String id;
  final String patientName;
  final String? birthDate;
  final String? phone;
  final String? email;
  final String? profession;
  final String? maritalStatus;
  final String? woundImagePath;
  final double? width;
  final double? length;
  final double? depth;
  final String? location;
  final String? locationCoordinates;
  final String? evolutionTime;
  final String? etiology;
  final bool? pressureInjury;
  final double? granulationPercent;
  final double? epithelializationPercent;
  final double? escharPercent;
  final double? dryNecrosisPercent;
  final int? painIntensity;
  final String? painReliefFactors;
  final String? painWorseningFactors;
  final bool? inflammationRubor;
  final bool? inflammationCalor;
  final bool? inflammationEdema;
  final bool? inflammationPain;
  final bool? inflammationFunctionLoss;
  final bool? infectionErythema;
  final bool? infectionCalor;
  final bool? infectionEdema;
  final bool? infectionPain;
  final bool? infectionPurulentExudate;
  final bool? infectionFetidOdor;
  final bool? infectionHealingDelay;
  final bool? culturePerformed;
  final String? exudateQuantity;
  final String? exudateType;
  final String? exudateConsistency;
  final String? edgeCharacteristics;
  final String? edgeAttachment;
  final bool? edgeDetached;
  final String? healingVelocity;
  final bool? tunnelsPresent;
  final String? tunnelLocation;
  final String? perilesionalSkinMoisture;
  final String? skinAlterationExtent;
  final String? skinCondition;
  final String? observations;
  final String? treatmentPlan;
  final String? consultationDate;
  final String? consultationTime;
  final String? professionalName;
  final String? professionalCorenCrm;
  final String? returnDate;
  final String? activityLevel;
  final String? understandingAdherence;
  final String? socialSupport;
  final bool? physicalActivity;
  final bool? alcoholConsumption;
  final bool? smoker;
  final String? nutritionalAssessment;
  final double? waterIntake;
  final String? treatmentObjective;
  final String? healingHistory;
  final bool? hasAllergy;
  final String? allergies;
  final bool? surgeriesPerformed;
  final String? surgeriesDetails;
  final bool? claudication;
  final bool? restPain;
  final String? peripheralPulses;
  final String? comorbidities;
  final String? medications;
  final String createdAt;
  final String updatedAt;

  WoundAssessment({
    String? id,
    required this.patientName,
    this.birthDate,
    this.phone,
    this.email,
    this.profession,
    this.maritalStatus,
    this.woundImagePath,
    this.width,
    this.length,
    this.depth,
    this.location,
    this.locationCoordinates,
    this.evolutionTime,
    this.etiology,
    this.pressureInjury,
    this.granulationPercent,
    this.epithelializationPercent,
    this.escharPercent,
    this.dryNecrosisPercent,
    this.painIntensity,
    this.painReliefFactors,
    this.painWorseningFactors,
    this.inflammationRubor,
    this.inflammationCalor,
    this.inflammationEdema,
    this.inflammationPain,
    this.inflammationFunctionLoss,
    this.infectionErythema,
    this.infectionCalor,
    this.infectionEdema,
    this.infectionPain,
    this.infectionPurulentExudate,
    this.infectionFetidOdor,
    this.infectionHealingDelay,
    this.culturePerformed,
    this.exudateQuantity,
    this.exudateType,
    this.exudateConsistency,
    this.edgeCharacteristics,
    this.edgeAttachment,
    this.edgeDetached,
    this.healingVelocity,
    this.tunnelsPresent,
    this.tunnelLocation,
    this.perilesionalSkinMoisture,
    this.skinAlterationExtent,
    this.skinCondition,
    this.observations,
    this.treatmentPlan,
    this.consultationDate,
    this.consultationTime,
    this.professionalName,
    this.professionalCorenCrm,
    this.returnDate,
    this.activityLevel,
    this.understandingAdherence,
    this.socialSupport,
    this.physicalActivity,
    this.alcoholConsumption,
    this.smoker,
    this.nutritionalAssessment,
    this.waterIntake,
    this.treatmentObjective,
    this.healingHistory,
    this.hasAllergy,
    this.allergies,
    this.surgeriesPerformed,
    this.surgeriesDetails,
    this.claudication,
    this.restPain,
    this.peripheralPulses,
    this.comorbidities,
    this.medications,
    String? createdAt,
    String? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_name': patientName,
      'birth_date': birthDate,
      'phone': phone,
      'email': email,
      'profession': profession,
      'marital_status': maritalStatus,
      'wound_image_path': woundImagePath,
      'width': width,
      'length': length,
      'depth': depth,
      'location': location,
      'location_coordinates': locationCoordinates,
      'evolution_time': evolutionTime,
      'etiology': etiology,
      'pressure_injury': pressureInjury == true ? 1 : 0,
      'granulation_percent': granulationPercent,
      'epithelialization_percent': epithelializationPercent,
      'eschar_percent': escharPercent,
      'dry_necrosis_percent': dryNecrosisPercent,
      'pain_intensity': painIntensity,
      'pain_relief_factors': painReliefFactors,
      'pain_worsening_factors': painWorseningFactors,
      'inflammation_rubor': inflammationRubor == true ? 1 : 0,
      'inflammation_calor': inflammationCalor == true ? 1 : 0,
      'inflammation_edema': inflammationEdema == true ? 1 : 0,
      'inflammation_pain': inflammationPain == true ? 1 : 0,
      'inflammation_function_loss': inflammationFunctionLoss == true ? 1 : 0,
      'infection_erythema': infectionErythema == true ? 1 : 0,
      'infection_calor': infectionCalor == true ? 1 : 0,
      'infection_edema': infectionEdema == true ? 1 : 0,
      'infection_pain': infectionPain == true ? 1 : 0,
      'infection_purulent_exudate': infectionPurulentExudate == true ? 1 : 0,
      'infection_fetid_odor': infectionFetidOdor == true ? 1 : 0,
      'infection_healing_delay': infectionHealingDelay == true ? 1 : 0,
      'culture_performed': culturePerformed == true ? 1 : 0,
      'exudate_quantity': exudateQuantity,
      'exudate_type': exudateType,
      'exudate_consistency': exudateConsistency,
      'edge_characteristics': edgeCharacteristics,
      'edge_attachment': edgeAttachment,
      'edge_detached': edgeDetached == true ? 1 : 0,
      'healing_velocity': healingVelocity,
      'tunnels_present': tunnelsPresent == true ? 1 : 0,
      'tunnel_location': tunnelLocation,
      'perilesional_skin_moisture': perilesionalSkinMoisture,
      'skin_alteration_extent': skinAlterationExtent,
      'skin_condition': skinCondition,
      'observations': observations,
      'treatment_plan': treatmentPlan,
      'consultation_date': consultationDate,
      'consultation_time': consultationTime,
      'professional_name': professionalName,
      'professional_coren_crm': professionalCorenCrm,
      'return_date': returnDate,
      'activity_level': activityLevel,
      'understanding_adherence': understandingAdherence,
      'social_support': socialSupport,
      'physical_activity': physicalActivity == true ? 1 : 0,
      'alcohol_consumption': alcoholConsumption == true ? 1 : 0,
      'smoker': smoker == true ? 1 : 0,
      'nutritional_assessment': nutritionalAssessment,
      'water_intake': waterIntake,
      'treatment_objective': treatmentObjective,
      'healing_history': healingHistory,
      'has_allergy': hasAllergy == true ? 1 : 0,
      'allergies': allergies,
      'surgeries_performed': surgeriesPerformed == true ? 1 : 0,
      'surgeries_details': surgeriesDetails,
      'claudication': claudication == true ? 1 : 0,
      'rest_pain': restPain == true ? 1 : 0,
      'peripheral_pulses': peripheralPulses,
      'comorbidities': comorbidities,
      'medications': medications,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory WoundAssessment.fromMap(Map<String, dynamic> map) {
    return WoundAssessment(
      id: map['id'],
      patientName: map['patient_name'],
      birthDate: map['birth_date'],
      phone: map['phone'],
      email: map['email'],
      profession: map['profession'],
      maritalStatus: map['marital_status'],
      woundImagePath: map['wound_image_path'],
      width: map['width']?.toDouble(),
      length: map['length']?.toDouble(),
      depth: map['depth']?.toDouble(),
      location: map['location'],
      locationCoordinates: map['location_coordinates'],
      evolutionTime: map['evolution_time'],
      etiology: map['etiology'],
      pressureInjury: map['pressure_injury'] == 1,
      granulationPercent: map['granulation_percent']?.toDouble(),
      epithelializationPercent: map['epithelialization_percent']?.toDouble(),
      escharPercent: map['eschar_percent']?.toDouble(),
      dryNecrosisPercent: map['dry_necrosis_percent']?.toDouble(),
      painIntensity: map['pain_intensity'],
      painReliefFactors: map['pain_relief_factors'],
      painWorseningFactors: map['pain_worsening_factors'],
      inflammationRubor: map['inflammation_rubor'] == 1,
      inflammationCalor: map['inflammation_calor'] == 1,
      inflammationEdema: map['inflammation_edema'] == 1,
      inflammationPain: map['inflammation_pain'] == 1,
      inflammationFunctionLoss: map['inflammation_function_loss'] == 1,
      infectionErythema: map['infection_erythema'] == 1,
      infectionCalor: map['infection_calor'] == 1,
      infectionEdema: map['infection_edema'] == 1,
      infectionPain: map['infection_pain'] == 1,
      infectionPurulentExudate: map['infection_purulent_exudate'] == 1,
      infectionFetidOdor: map['infection_fetid_odor'] == 1,
      infectionHealingDelay: map['infection_healing_delay'] == 1,
      culturePerformed: map['culture_performed'] == 1,
      exudateQuantity: map['exudate_quantity'],
      exudateType: map['exudate_type'],
      exudateConsistency: map['exudate_consistency'],
      edgeCharacteristics: map['edge_characteristics'],
      edgeAttachment: map['edge_attachment'],
      edgeDetached: map['edge_detached'] == 1,
      healingVelocity: map['healing_velocity'],
      tunnelsPresent: map['tunnels_present'] == 1,
      tunnelLocation: map['tunnel_location'],
      perilesionalSkinMoisture: map['perilesional_skin_moisture'],
      skinAlterationExtent: map['skin_alteration_extent'],
      skinCondition: map['skin_condition'],
      observations: map['observations'],
      treatmentPlan: map['treatment_plan'],
      consultationDate: map['consultation_date'],
      consultationTime: map['consultation_time'],
      professionalName: map['professional_name'],
      professionalCorenCrm: map['professional_coren_crm'],
      returnDate: map['return_date'],
      activityLevel: map['activity_level'],
      understandingAdherence: map['understanding_adherence'],
      socialSupport: map['social_support'],
      physicalActivity: map['physical_activity'] == 1,
      alcoholConsumption: map['alcohol_consumption'] == 1,
      smoker: map['smoker'] == 1,
      nutritionalAssessment: map['nutritional_assessment'],
      waterIntake: map['water_intake']?.toDouble(),
      treatmentObjective: map['treatment_objective'],
      healingHistory: map['healing_history'],
      hasAllergy: map['has_allergy'] == 1,
      allergies: map['allergies'],
      surgeriesPerformed: map['surgeries_performed'] == 1,
      surgeriesDetails: map['surgeries_details'],
      claudication: map['claudication'] == 1,
      restPain: map['rest_pain'] == 1,
      peripheralPulses: map['peripheral_pulses'],
      comorbidities: map['comorbidities'],
      medications: map['medications'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  WoundAssessment copyWith({
    String? patientName,
    String? birthDate,
    String? phone,
    String? email,
    String? profession,
    String? maritalStatus,
    String? woundImagePath,
    double? width,
    double? length,
    double? depth,
    String? location,
    String? locationCoordinates,
    String? evolutionTime,
    String? etiology,
    bool? pressureInjury,
    double? granulationPercent,
    double? epithelializationPercent,
    double? escharPercent,
    double? dryNecrosisPercent,
    int? painIntensity,
    String? painReliefFactors,
    String? painWorseningFactors,
    bool? inflammationRubor,
    bool? inflammationCalor,
    bool? inflammationEdema,
    bool? inflammationPain,
    bool? inflammationFunctionLoss,
    bool? infectionErythema,
    bool? infectionCalor,
    bool? infectionEdema,
    bool? infectionPain,
    bool? infectionPurulentExudate,
    bool? infectionFetidOdor,
    bool? infectionHealingDelay,
    bool? culturePerformed,
    String? exudateQuantity,
    String? exudateType,
    String? exudateConsistency,
    String? edgeCharacteristics,
    String? edgeAttachment,
    bool? edgeDetached,
    String? healingVelocity,
    bool? tunnelsPresent,
    String? tunnelLocation,
    String? perilesionalSkinMoisture,
    String? skinAlterationExtent,
    String? skinCondition,
    String? observations,
    String? treatmentPlan,
    String? consultationDate,
    String? consultationTime,
    String? professionalName,
    String? professionalCorenCrm,
    String? returnDate,
    String? activityLevel,
    String? understandingAdherence,
    String? socialSupport,
    bool? physicalActivity,
    bool? alcoholConsumption,
    bool? smoker,
    String? nutritionalAssessment,
    double? waterIntake,
    String? treatmentObjective,
    String? healingHistory,
    bool? hasAllergy,
    String? allergies,
    bool? surgeriesPerformed,
    String? surgeriesDetails,
    bool? claudication,
    bool? restPain,
    String? peripheralPulses,
    String? comorbidities,
    String? medications,
  }) {
    return WoundAssessment(
      id: id,
      patientName: patientName ?? this.patientName,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profession: profession ?? this.profession,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      woundImagePath: woundImagePath ?? this.woundImagePath,
      width: width ?? this.width,
      length: length ?? this.length,
      depth: depth ?? this.depth,
      location: location ?? this.location,
      locationCoordinates: locationCoordinates ?? this.locationCoordinates,
      evolutionTime: evolutionTime ?? this.evolutionTime,
      etiology: etiology ?? this.etiology,
      pressureInjury: pressureInjury ?? this.pressureInjury,
      granulationPercent: granulationPercent ?? this.granulationPercent,
      epithelializationPercent: epithelializationPercent ?? this.epithelializationPercent,
      escharPercent: escharPercent ?? this.escharPercent,
      dryNecrosisPercent: dryNecrosisPercent ?? this.dryNecrosisPercent,
      painIntensity: painIntensity ?? this.painIntensity,
      painReliefFactors: painReliefFactors ?? this.painReliefFactors,
      painWorseningFactors: painWorseningFactors ?? this.painWorseningFactors,
      inflammationRubor: inflammationRubor ?? this.inflammationRubor,
      inflammationCalor: inflammationCalor ?? this.inflammationCalor,
      inflammationEdema: inflammationEdema ?? this.inflammationEdema,
      inflammationPain: inflammationPain ?? this.inflammationPain,
      inflammationFunctionLoss: inflammationFunctionLoss ?? this.inflammationFunctionLoss,
      infectionErythema: infectionErythema ?? this.infectionErythema,
      infectionCalor: infectionCalor ?? this.infectionCalor,
      infectionEdema: infectionEdema ?? this.infectionEdema,
      infectionPain: infectionPain ?? this.infectionPain,
      infectionPurulentExudate: infectionPurulentExudate ?? this.infectionPurulentExudate,
      infectionFetidOdor: infectionFetidOdor ?? this.infectionFetidOdor,
      infectionHealingDelay: infectionHealingDelay ?? this.infectionHealingDelay,
      culturePerformed: culturePerformed ?? this.culturePerformed,
      exudateQuantity: exudateQuantity ?? this.exudateQuantity,
      exudateType: exudateType ?? this.exudateType,
      exudateConsistency: exudateConsistency ?? this.exudateConsistency,
      edgeCharacteristics: edgeCharacteristics ?? this.edgeCharacteristics,
      edgeAttachment: edgeAttachment ?? this.edgeAttachment,
      edgeDetached: edgeDetached ?? this.edgeDetached,
      healingVelocity: healingVelocity ?? this.healingVelocity,
      tunnelsPresent: tunnelsPresent ?? this.tunnelsPresent,
      tunnelLocation: tunnelLocation ?? this.tunnelLocation,
      perilesionalSkinMoisture: perilesionalSkinMoisture ?? this.perilesionalSkinMoisture,
      skinAlterationExtent: skinAlterationExtent ?? this.skinAlterationExtent,
      skinCondition: skinCondition ?? this.skinCondition,
      observations: observations ?? this.observations,
      treatmentPlan: treatmentPlan ?? this.treatmentPlan,
      consultationDate: consultationDate ?? this.consultationDate,
      consultationTime: consultationTime ?? this.consultationTime,
      professionalName: professionalName ?? this.professionalName,
      professionalCorenCrm: professionalCorenCrm ?? this.professionalCorenCrm,
      returnDate: returnDate ?? this.returnDate,
      activityLevel: activityLevel ?? this.activityLevel,
      understandingAdherence: understandingAdherence ?? this.understandingAdherence,
      socialSupport: socialSupport ?? this.socialSupport,
      physicalActivity: physicalActivity ?? this.physicalActivity,
      alcoholConsumption: alcoholConsumption ?? this.alcoholConsumption,
      smoker: smoker ?? this.smoker,
      nutritionalAssessment: nutritionalAssessment ?? this.nutritionalAssessment,
      waterIntake: waterIntake ?? this.waterIntake,
      treatmentObjective: treatmentObjective ?? this.treatmentObjective,
      healingHistory: healingHistory ?? this.healingHistory,
      hasAllergy: hasAllergy ?? this.hasAllergy,
      allergies: allergies ?? this.allergies,
      surgeriesPerformed: surgeriesPerformed ?? this.surgeriesPerformed,
      surgeriesDetails: surgeriesDetails ?? this.surgeriesDetails,
      claudication: claudication ?? this.claudication,
      restPain: restPain ?? this.restPain,
      peripheralPulses: peripheralPulses ?? this.peripheralPulses,
      comorbidities: comorbidities ?? this.comorbidities,
      medications: medications ?? this.medications,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class AssessmentTimer {
  final String id;
  final String woundAssessmentId;
  final String timerName;
  final String startTime;
  final String? endTime;
  final int? durationSeconds;
  final bool isActive;
  final String createdAt;

  AssessmentTimer({
    String? id,
    required this.woundAssessmentId,
    required this.timerName,
    required this.startTime,
    this.endTime,
    this.durationSeconds,
    required this.isActive,
    String? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wound_assessment_id': woundAssessmentId,
      'timer_name': timerName,
      'start_time': startTime,
      'end_time': endTime,
      'duration_seconds': durationSeconds,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory AssessmentTimer.fromMap(Map<String, dynamic> map) {
    return AssessmentTimer(
      id: map['id'],
      woundAssessmentId: map['wound_assessment_id'],
      timerName: map['timer_name'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      durationSeconds: map['duration_seconds'],
      isActive: map['is_active'] == 1,
      createdAt: map['created_at'],
    );
  }
}

