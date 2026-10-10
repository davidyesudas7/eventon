import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/vendor_profile.dart';
import '../repositories/vendor_repository.dart';

class GetVendorProfileUseCase implements UseCase<VendorProfile, String> {
  final VendorRepository repository;

  GetVendorProfileUseCase(this.repository);

  @override
  Future<Either<Failure, VendorProfile>> call(String id) async {
    return await repository.getVendorProfile(id);
  }
}
