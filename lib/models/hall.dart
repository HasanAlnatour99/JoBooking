import 'package:image_picker/image_picker.dart';

class HallModel {
  String? address, conditions, name, description,hallID,ownID,rated,phone,type;
  int? visitors;
  Map? price;
  bool? promotion;
  String? promotionImage;
  List<dynamic>? images;


  HallModel({this.promotionImage,this.promotion,this.name,this.address,this.description,this.type,this.conditions,this.hallID,this.images,this.ownID,this.price,this.rated,this.visitors,this.phone});

  HallModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    hallID = map['hallID'];
    ownID = map['ownID'];
    name = map['name'];
    description = map['description'];
    address = map['address'];
    conditions = map['conditions'];
    rated = map['rated'];
    visitors = map['visitors'];
    phone = map['phone'];
    images = map['images'];
    price = map['price'];
    type = map['type'];
    promotion = map['promotion'];
    promotionImage = map['promotionImage'];
  }

  toJson() {
    return {
      'promotion':promotion,
      'promotionImage':promotionImage,
      'hallID': hallID,
      'ownID': ownID,
      'name': name,
      'description': description,
      'address':address,
      'conditions':conditions,
      'rated':rated,
      'visitors':visitors,
      'phone':phone,
      'images':images,
      'price':price,
      'type':type,
    };
  }
}