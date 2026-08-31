import 'package:equatable/equatable.dart';

class CompanyInfoEntity extends Equatable {
  final String phone1;
  final String phone2;
  final String whatsapp;
  final String email;
  final String address;
  final String googleMapsUrl;
  final String facebookUrl;
  final String whatsappLink;
  final String youtubeUrl;
  final String instagramUrl;
  final String linkedinUrl;

  const CompanyInfoEntity({
    this.phone1 = '',
    this.phone2 = '',
    this.whatsapp = '',
    this.email = '',
    this.address = '',
    this.googleMapsUrl = '',
    this.facebookUrl = '',
    this.whatsappLink = '',
    this.youtubeUrl = '',
    this.instagramUrl = '',
    this.linkedinUrl = '',
  });

  @override
  List<Object?> get props => [
        phone1,
        phone2,
        whatsapp,
        email,
        address,
        googleMapsUrl,
        facebookUrl,
        whatsappLink,
        youtubeUrl,
        instagramUrl,
        linkedinUrl,
      ];
}
