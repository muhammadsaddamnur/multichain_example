import 'package:flutter/material.dart';

class MultiDropdown extends StatelessWidget {
  final void Function()? onTap;
  final String? image;
  final String title;
  final String? subtitle;
  const MultiDropdown({
    Key? key,
    this.image,
    this.onTap,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: const Color(0xff2B314F),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    image == null || image == 'null'
                        ? const CircleAvatar()
                        : CircleAvatar(
                            backgroundImage: NetworkImage(image!),
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.white.withOpacity(0.5),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
