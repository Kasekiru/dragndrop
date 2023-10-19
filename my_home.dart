import 'package:flutter/material.dart';
import 'package:m04/movie_card.dart';
import 'package:m04/pertemuan4_provider.dart';
import 'package:provider/provider.dart';

class MyHomePertemuan4 extends StatefulWidget {
  const MyHomePertemuan4({Key? key}) : super(key: key);

  @override
  State<MyHomePertemuan4> createState() => _MyHomePertemuan4State();
}

class _MyHomePertemuan4State extends State<MyHomePertemuan4> {
  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ProviderPertemuan4>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Movie'),
      ),
      body: Container(
        child: ListView(
          children: [
            DropdownButton<String>(
              value: tmp.selectedValue,
              items: tmp.dropdownItems.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                tmp.selectedValue = newValue!;
                tmp.numPage = 1;
                if (tmp.selectedValue == tmp.dropdownItems[0]) {
                  tmp.loadApiNowPlaying();
                } else if (tmp.selectedValue == tmp.dropdownItems[1]) {
                  tmp.loadApiTopRated();
                } else if (tmp.selectedValue == tmp.dropdownItems[2]) {
                  tmp.loadApiPopular();
                } else if (tmp.selectedValue == tmp.dropdownItems[3]) {
                  tmp.loadApiUpcoming();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tmp.selectedValue,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (tmp.selectedValue == tmp.dropdownItems[0])
              ...List.generate(tmp.jsonResultNowPlaying?.results.length ?? 0,
                  (index) {
                return Builder(builder: (context) {
                  return MovieCard(
                    id: tmp.jsonResultNowPlaying!.results[index].id,
                    img: tmp.jsonResultNowPlaying!.results[index].posterPath,
                    name:
                        tmp.jsonResultNowPlaying!.results[index].originalTitle,
                    desc: tmp.jsonResultNowPlaying!.results[index].overview,
                    genre: tmp.jsonResultNowPlaying!.results[index].genreIds,
                    release:
                        tmp.jsonResultNowPlaying!.results[index].releaseDate,
                    vote: tmp.jsonResultNowPlaying!.results[index].voteAverage,
                  );
                });
              }),
            if (tmp.selectedValue == tmp.dropdownItems[1])
              ...List.generate(tmp.jsonResultTopRated?.results.length ?? 0,
                  (index) {
                return Builder(builder: (context) {
                  return MovieCard(
                    id: tmp.jsonResultTopRated!.results[index].id,
                    img: tmp.jsonResultTopRated!.results[index].posterPath,
                    name: tmp.jsonResultTopRated!.results[index].originalTitle,
                    desc: tmp.jsonResultTopRated!.results[index].overview,
                    genre: tmp.jsonResultTopRated!.results[index].genreIds,
                    release: tmp.jsonResultTopRated!.results[index].releaseDate,
                    vote: tmp.jsonResultTopRated!.results[index].voteAverage,
                  );
                });
              }),
            if (tmp.selectedValue == tmp.dropdownItems[2] || tmp.selectedValue == tmp.dropdownItems[3])
              ...List.generate(tmp.jsonResultUpcoming?.results.length ?? 0,
                  (index) {
                return Builder(builder: (context) {
                  return MovieCard(
                    id: tmp.jsonResultUpcoming!.results[index].id,
                    img: tmp.jsonResultUpcoming!.results[index].posterPath,
                    name: tmp.jsonResultUpcoming!.results[index].originalTitle,
                    desc: tmp.jsonResultUpcoming!.results[index].overview,
                    genre: tmp.jsonResultUpcoming!.results[index].genreIds,
                    release: tmp.jsonResultUpcoming!.results[index].releaseDate,
                    vote: tmp.jsonResultUpcoming!.results[index].voteAverage,
                  );
                });
              }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      var vrb = tmp.numPage;
                      if (vrb > 1) {
                        tmp.numPage = vrb - 1;
                        if (tmp.selectedValue == tmp.dropdownItems[0]) {
                          tmp.loadApiNowPlaying();
                        } else if (tmp.selectedValue == tmp.dropdownItems[1]) {
                          tmp.loadApiTopRated();
                        } else if (tmp.selectedValue == tmp.dropdownItems[2]) {
                          tmp.loadApiPopular();
                        } else if (tmp.selectedValue == tmp.dropdownItems[3]) {
                          tmp.loadApiUpcoming();
                        }
                      }
                    },
                    icon: Icon(Icons.arrow_left_rounded),
                    label: Text('Prev Page'),
                  ),
                  Spacer(),
                  Text('Page : ${tmp.numPage}'),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      var vrb = tmp.numPage;
                      tmp.numPage = vrb + 1;
                      if (tmp.selectedValue == tmp.dropdownItems[0]) {
                        tmp.loadApiNowPlaying();
                      } else if (tmp.selectedValue == tmp.dropdownItems[1]) {
                        tmp.loadApiTopRated();
                      } else if (tmp.selectedValue == tmp.dropdownItems[2]) {
                        tmp.loadApiPopular();
                      } else if (tmp.selectedValue == tmp.dropdownItems[3]) {
                        tmp.loadApiUpcoming();
                      }
                    },
                    icon: Icon(Icons.arrow_right_rounded),
                    label: Text('Next Page'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
