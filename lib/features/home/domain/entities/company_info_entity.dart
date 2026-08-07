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
    this.phone1 = '01780-885841',
    this.phone2 = '09613 700 750',
    this.whatsapp = '+8801780885841',
    this.email = 'aquabd112@gmail.com',
    this.address = 'House 72, Janata Housing Road, 3 Ring Road, Dhaka 1219',
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
