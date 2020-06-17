class DetailsModel {
  bool success;
  DetailsGoodsData data;
  int code;

  DetailsModel({this.success, this.data, this.code});

  DetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new DetailsGoodsData.fromJson(json['data']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class DetailsGoodsData {
  List<GoodsComments> goodsComments;
  String sId;
  String id;
  GoodsInfo goodsInfo;
  AdvertisePicture advertisePicture;
  int iV;

  DetailsGoodsData(
      {this.goodsComments,
      this.sId,
      this.id,
      this.goodsInfo,
      this.advertisePicture,
      this.iV});

  DetailsGoodsData.fromJson(Map<String, dynamic> json) {
    if (json['goodsComments'] != null) {
      goodsComments = new List<GoodsComments>();
      json['goodsComments'].forEach((v) {
        goodsComments.add(new GoodsComments.fromJson(v));
      });
    }
    sId = json['_id'];
    id = json['id'];
    goodsInfo = json['goodsInfo'] != null
        ? new GoodsInfo.fromJson(json['goodsInfo'])
        : null;
    advertisePicture = json['advertisePicture'] != null
        ? new AdvertisePicture.fromJson(json['advertisePicture'])
        : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.goodsComments != null) {
      data['goodsComments'] =
          this.goodsComments.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['id'] = this.id;
    if (this.goodsInfo != null) {
      data['goodsInfo'] = this.goodsInfo.toJson();
    }
    if (this.advertisePicture != null) {
      data['advertisePicture'] = this.advertisePicture.toJson();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class GoodsComments {
  int sCORE;
  String comments;
  String userName;
  int discussTime;

  GoodsComments({this.sCORE, this.comments, this.userName, this.discussTime});

  GoodsComments.fromJson(Map<String, dynamic> json) {
    sCORE = json['SCORE'];
    comments = json['comments'];
    userName = json['userName'];
    discussTime = json['discussTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SCORE'] = this.sCORE;
    data['comments'] = this.comments;
    data['userName'] = this.userName;
    data['discussTime'] = this.discussTime;
    return data;
  }
}

class GoodsInfo {
  String image5;
  int amount;
  String image3;
  String image4;
  String goodsId;
  String isOnline;
  String image1;
  String image2;
  String goodsSerialNumber;
  int oriPrice;
  double presentPrice;
  String comPic;
  int state;
  String shopId;
  String goodsName;
  String goodsDetail;

  GoodsInfo(
      {this.image5,
      this.amount,
      this.image3,
      this.image4,
      this.goodsId,
      this.isOnline,
      this.image1,
      this.image2,
      this.goodsSerialNumber,
      this.oriPrice,
      this.presentPrice,
      this.comPic,
      this.state,
      this.shopId,
      this.goodsName,
      this.goodsDetail});

  GoodsInfo.fromJson(Map<String, dynamic> json) {
    image5 = json['image5'];
    amount = json['amount'];
    image3 = json['image3'];
    image4 = json['image4'];
    goodsId = json['goodsId'];
    isOnline = json['isOnline'];
    image1 = json['image1'];
    image2 = json['image2'];
    goodsSerialNumber = json['goodsSerialNumber'];
    oriPrice = json['oriPrice'];
    presentPrice = json['presentPrice'];
    comPic = json['comPic'];
    state = json['state'];
    shopId = json['shopId'];
    goodsName = json['goodsName'];
    goodsDetail = json['goodsDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image5'] = this.image5;
    data['amount'] = this.amount;
    data['image3'] = this.image3;
    data['image4'] = this.image4;
    data['goodsId'] = this.goodsId;
    data['isOnline'] = this.isOnline;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['goodsSerialNumber'] = this.goodsSerialNumber;
    data['oriPrice'] = this.oriPrice;
    data['presentPrice'] = this.presentPrice;
    data['comPic'] = this.comPic;
    data['state'] = this.state;
    data['shopId'] = this.shopId;
    data['goodsName'] = this.goodsName;
    data['goodsDetail'] = this.goodsDetail;
    return data;
  }
}

class AdvertisePicture {
  String pICTUREADDRESS;
  String tOPLACE;

  AdvertisePicture({this.pICTUREADDRESS, this.tOPLACE});

  AdvertisePicture.fromJson(Map<String, dynamic> json) {
    pICTUREADDRESS = json['PICTURE_ADDRESS'];
    tOPLACE = json['TO_PLACE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PICTURE_ADDRESS'] = this.pICTUREADDRESS;
    data['TO_PLACE'] = this.tOPLACE;
    return data;
  }
}
