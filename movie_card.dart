import 'package:flutter/material.dart';
import 'package:m04/pertemuan4_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MovieCard extends StatelessWidget {
  MovieCard({
    super.key,
    required this.id,
    required this.img,
    required this.name,
    required this.desc,
    required this.release,
    required this.vote,
    this.genre,
  });
  int id = 0;
  String img = '';
  String name = '';
  String desc = '';
  List<int>? genre;
  DateTime? release;
  double vote;

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ProviderPertemuan4>(context);

    return Card(
      child: Row(
        children: [
          Container(
            child: Stack(children: [
              Image.network(
                (img != '/')
                    ? 'https://image.tmdb.org/t/p/w500$img'
                    : 'https://media.istockphoto.com/id/936182806/vector/no-image-available-sign.jpg?s=612x612&w=0&k=20&c=9HTEtmbZ6R59xewqyIQsI_pQl3W3QDJgnxFPIHb4wQE=',
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.64 - 2,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    desc,
                    softWrap: true,
                    maxLines: 4,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.grey[700], fontSize: 10),
                  ),
                  Spacer(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                          (genre ?? []).length,
                          (index) => Chip(
                            padding: EdgeInsets.all(0),
                            label: Text(
                              tmp.findGenre((genre ?? [])[index]),
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                            Text('$vote')
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'release :',
                            style: TextStyle(color: Colors.grey, fontSize: 8),
                          ),
                          Text(
                            (release == null)
                                ? ''
                                : DateFormat('dd/MM/yyyy').format(release!),
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
