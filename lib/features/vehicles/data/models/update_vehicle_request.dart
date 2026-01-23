/// Update Vehicle Request Model
/// Request body for updating a vehicle
class UpdateVehicleRequest {
  final String platNumber;
  final String carMake;
  final String carModel;
  final String color;

  const UpdateVehicleRequest({
    required this.platNumber,
    required this.carMake,
    required this.carModel,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'plat_number': platNumber,
      'car_make': carMake,
      'car_model': carModel,
      'color': color,
    };
  }
}

