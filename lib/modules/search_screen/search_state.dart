abstract class SearchState {}

class InitialSearchState extends SearchState {}

class TypingMedicineSearchState extends SearchState {}

class LoadingMedicineSearchState extends SearchState {}

class ErrorMedicineSearchState extends SearchState {}

class ClearSearchState extends SearchState {}

class FindingPharmacySearchState extends SearchState {}

class SuccessPharmacySearchState extends SearchState {}

class ErrorPharmacySearchState extends SearchState {}

class SuccessPharmaciesDetailSearchState extends SearchState {}

class ErrorPharmaciesDetailSearchState extends SearchState {}
