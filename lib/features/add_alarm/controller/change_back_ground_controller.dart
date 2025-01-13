import 'package:alarm/core/utils/constants/image_path.dart';
import 'package:get/get.dart';


class ChangeBackgroundController extends GetxController {
  var items = [
    {'title': 'Cute Dog in bed', 'image': 'https://s3-alpha-sig.figma.com/img/1ab9/2209/37616a088a90489b8c2c86ed19dde489?Expires=1737936000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=bblk~p94MQhNMXpnZ1ndrEn6bK1PP4b7rOvI8s~lHTx85iaEY9MiaWUTWwcEq~jDyB0tFZcWzvhO-KbdmQryfam6fieMtdNWLPsqgRnY-wyVqmVcwAO~zBQYbo5OgmU-SWAOVYFxdNrgkuVAqWlnHGa5qngOwewHfIofoZTK8lFcC3i2nMJ3mwk~iaZN2C7N0QillAlFhagA8Lz2IgS2accR7a9O6rFVS39aTLL0orKbWGQXRoSuKqMJng-96EvsoIGiXSMmdHdJqBcgRA5t3Ur-wOxzD~SO-6TkcjfM3rCEWSG57C6n6pmzKpd8r-1XmWBWvK472UTmBIjpgGwQ5g__','extraImage': ImagePath.extraImage,},
    {'title': 'Cute Cat under blanket', 'image': 'https://s3-alpha-sig.figma.com/img/0dd7/17e5/22fe5ceace1f02b5dcde94c675f1f7e5?Expires=1737936000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Xm0KVDkw53L09-Uglk3Sg9T5YSyYW-CgibbedTaBFI1TynN7ajqrDMGEG2ao4f6zarYb64s4Ix4cKJGLYxIWNRgprpRM2YjUjTRdDfQfN25tFQ8ldiyVrHgkuYM~J7PFmlVsLHzwXAj09ILvKBZYPuZNEDLiowsQlXC5ykeGHEfPmvs~~E~6m2BequH1p4cnsEPS~xXy8mJCQW0KZFv28j~qbLmQYN8SSERW3VPlVbewrrSpYA8zVfYsEbkQ3gvsLnSCK01j8S9sj972mocVvNhKcbPPaligSME1DyEmxym6WF5fye7KCbwQDLJlCHn3~G1N8IpT20HWGRCBoUA6eg__','extraImage': ImagePath.extraImage,},
    {'title': 'Cute Bird over sink', 'image': 'https://s3-alpha-sig.figma.com/img/6ac0/d979/e884f0f4d0cfc2be45e48a4302445d2e?Expires=1737936000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=JDbQoqCbJ3qyYKf3Zu-7Jr~P6YayWxIZgzkjgacDU4FZ9KMm4qlrL2iKhbZOFgJg9OHckI7NlOfFyQlCiIHxpODLcuZflwCTLr-zOwDW4XrkfR6KTZS333Ni0SUCLlLvnxtqR-rUmtTOuxDiuyHmDdYrlPA8iog0Lh4xVYvtwvlOsKtbIcFBTMjLkUx07iJ-3ysD4tOLtRn8V3BHEscHPa8DE7mzqe1gYUID-fqJR9-l77PBiX0k0KLPK6hAQ1ppPnz48qy4WbB008MnCBG5XAkZ-h~MVz-OqYAFjABveP0mW7Rc4w0RPKZRTCQcnZp4AAh~mMeaI4i1fiaI8RSoNg__','extraImage': ImagePath.extraImage,},
    {'title': 'Cute Dog in bed', 'image': 'https://s3-alpha-sig.figma.com/img/31c1/107f/6d152a3d3266738834e2d1c9e3e0cde0?Expires=1737936000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=bmDuZwcjilwDTcpWtLXqof7bUpEzUlUVPuxrXTV3iFC3GRXpqwscJAmhx-ua~k24Kly-KWe2uxXTu1a7CSV9sPigu~nz2sFodt6U8NPwqGepR2qUuX04lG6NlrpphiHj3Y-Xzqekh5a0qYCwpU0CQ5EAwU05IOhWYWu-YBskNBqhz7Db7a3bkms-nPMwXlgMA16vyb~FYjdu1q~SsCNFaPPW7wRGYF0RVSqdOaiB2km53FCV-EXa9JlwW4zMYfUmwARRCijoRXhWHaxjy571ll1bITH-hC-xo-wlLIRmkCEuLeiR7nqyK-ayEQ8gidHryJSHNucD8GfN0EmcHpK27w__','extraImage': ImagePath.extraImage,},
    {'title': 'Cute Dog in bed', 'image': 'https://s3-alpha-sig.figma.com/img/1ab9/2209/37616a088a90489b8c2c86ed19dde489?Expires=1737936000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=bblk~p94MQhNMXpnZ1ndrEn6bK1PP4b7rOvI8s~lHTx85iaEY9MiaWUTWwcEq~jDyB0tFZcWzvhO-KbdmQryfam6fieMtdNWLPsqgRnY-wyVqmVcwAO~zBQYbo5OgmU-SWAOVYFxdNrgkuVAqWlnHGa5qngOwewHfIofoZTK8lFcC3i2nMJ3mwk~iaZN2C7N0QillAlFhagA8Lz2IgS2accR7a9O6rFVS39aTLL0orKbWGQXRoSuKqMJng-96EvsoIGiXSMmdHdJqBcgRA5t3Ur-wOxzD~SO-6TkcjfM3rCEWSG57C6n6pmzKpd8r-1XmWBWvK472UTmBIjpgGwQ5g__','extraImage': ImagePath.extraImage,},
    {'title': 'Cute Cat under blanket', 'image': 'https://s3-alpha-sig.figma.com/img/0dd7/17e5/22fe5ceace1f02b5dcde94c675f1f7e5?Expires=1737936000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Xm0KVDkw53L09-Uglk3Sg9T5YSyYW-CgibbedTaBFI1TynN7ajqrDMGEG2ao4f6zarYb64s4Ix4cKJGLYxIWNRgprpRM2YjUjTRdDfQfN25tFQ8ldiyVrHgkuYM~J7PFmlVsLHzwXAj09ILvKBZYPuZNEDLiowsQlXC5ykeGHEfPmvs~~E~6m2BequH1p4cnsEPS~xXy8mJCQW0KZFv28j~qbLmQYN8SSERW3VPlVbewrrSpYA8zVfYsEbkQ3gvsLnSCK01j8S9sj972mocVvNhKcbPPaligSME1DyEmxym6WF5fye7KCbwQDLJlCHn3~G1N8IpT20HWGRCBoUA6eg__','extraImage': ImagePath.extraImage,},
  ].obs;

  var isPlaying = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize isPlaying list with the same length as items
    isPlaying.value = List.generate(items.length, (_) => false);
  }

  void togglePlay(int index) {
    isPlaying[index] = !isPlaying[index];
    // Ensure only one item is active at a time
    for (int i = 0; i < isPlaying.length; i++) {
      if (i != index) {
        isPlaying[i] = false;
      }
    }
  }
}