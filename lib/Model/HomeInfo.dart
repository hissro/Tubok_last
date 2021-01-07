
/*class HomeInfo {
  final String bus_id;
  final String bus_title;
  final String bus_slug;
  final String bus_email;
  final String bus_description;
  final String bus_google_street;
  final String bus_contact;
  final String bus_logo;
  final String appointment_count;
  final int appointments;
  final String reviews_count;

  HomeInfo(
      this.bus_id,
      this.bus_title,
      this.bus_slug,
      this.bus_email,
      this.bus_description,
      this.bus_google_street,
      this.bus_contact,
      this.bus_logo,
      this.appointment_count,
      this.appointments,
      this.reviews_count);
}
*/



class HomeInfo {
  String bus_title;
  String bus_email;
  String bus_logo;
  HomeInfo({this.bus_title, this.bus_email, this.bus_logo});
  factory HomeInfo.fromJson(Map<String, dynamic> parsedJson)
  {
    print(parsedJson['bus_title']);
    print(parsedJson['bus_title']);
    print(parsedJson['bus_logo']);
      return HomeInfo(
          bus_title: parsedJson['bus_title'],
          bus_email: parsedJson['bus_email'],
          bus_logo: parsedJson['bus_logo']);

  }
}
