import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/company_info_entity.dart';

class CompanyInfoModel extends CompanyInfoEntity {
  const CompanyInfoModel({
    super.phone1,
    super.phone2,
    super.whatsapp,
    super.email,
    super.address,
    super.googleMapsUrl,
    super.facebookUrl,
    super.whatsappLink,
    super.youtubeUrl,
    super.instagramUrl,
    super.linkedinUrl,
  });

  factory CompanyInfoModel.fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists) {
      return const CompanyInfoModel();
    }
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CompanyInfoModel(
      phone1: data['phone1'] as String? ?? '',
      phone2: data['phone2'] as String? ?? '',
      whatsapp: data['whatsappNumber'] as String? ?? data['whatsapp'] as String? ?? '',
      email: data['email'] as String? ?? '',
      address: data['address'] as String? ?? '',
      googleMapsUrl: data['googleMapsUrl'] as String? ?? '',
      facebookUrl: data['facebookUrl'] as String? ?? '',
      whatsappLink: data['whatsappLink'] as String? ?? '',
      youtubeUrl: data['youtubeUrl'] as String? ?? '',
      instagramUrl: data['instagramUrl'] as String? ?? '',
      linkedinUrl: data['linkedinUrl'] as String? ?? '',
    );
  }
}
