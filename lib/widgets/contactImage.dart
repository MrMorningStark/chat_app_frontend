import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactImage extends StatelessWidget {
  final double size;
  final BoxFit fit;
  final Contact? contact;
  final String? photoURL;
  final String? displayName;
  final VoidCallback? onTapImage;

  const ContactImage({
    super.key,
    this.size = 50,
    this.contact,
    this.fit = BoxFit.cover,
    this.photoURL,
    this.displayName,
    this.onTapImage,
  });

  @override
  Widget build(BuildContext context) {
    Widget fallbackImage({bool rounded = true, double? iconSize}) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rounded ? (size / 2) : 0),
          color: Colors.blueGrey,
        ),
        child: Icon(
          Icons.person,
          size: iconSize ?? size / 2,
          color: Colors.white,
        ),
      );
    }

    Function onTap() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Positioned(
                top: 80,
                left: MediaQuery.of(context).size.width / 2 - 250 / 2,
                child: Column(
                  children: [
                    CachedNetworkImage(
                      height: 250,
                      width: 250,
                      imageUrl: photoURL ?? "",
                      fit: fit,
                      placeholder: (context, url) =>
                          fallbackImage(rounded: false, iconSize: 100),
                      errorWidget: (context, url, error) =>
                          fallbackImage(rounded: false, iconSize: 100),
                    ),
                    Container(
                      width: 250,
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.message,
                            size: 28,
                            color: Theme.of(context).tabBarTheme.indicatorColor,
                          ),
                          Icon(
                            Icons.info_outline,
                            size: 28,
                            color: Theme.of(context).tabBarTheme.indicatorColor,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 80,
                left: MediaQuery.of(context).size.width / 2 - 250 / 2,
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  width: 250,
                  height: 45,
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    displayName ?? contact?.displayName ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
      return () {};
    }

    return InkWell(
      onTap: onTapImage ?? onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: CachedNetworkImage(
          height: size,
          width: size,
          imageUrl: photoURL ?? "",
          fit: fit,
          imageBuilder: (context, imageProvider) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: Image(
                image: imageProvider,
                fit: fit,
              ),
            );
          },
          placeholder: (context, url) => fallbackImage(),
          errorWidget: (context, url, error) => fallbackImage(),
        ),
      ),
    );
  }
}
