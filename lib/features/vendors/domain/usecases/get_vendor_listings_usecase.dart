import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/vendor_listing.dart';
import '../repositories/vendor_repository.dart';

class GetVendorListingsUseCase implements UseCase<List<VendorListing>, String> {
  final VendorRepository repository;

  GetVendorListingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<VendorListing>>> call(String vendorId) async {
    return await repository.getVendorListings(vendorId);
  }
}
