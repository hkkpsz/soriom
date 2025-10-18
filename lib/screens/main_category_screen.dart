import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import 'sub_category_screen.dart';

class MainCategoryScreen extends StatelessWidget {
  const MainCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.quiz, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiz Kategorini Seç!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Column(
                children: [
                  CategoryCard(
                    icon: Icons.photo_camera,
                    title: 'Fotoğraf',
                    subtitle: 'Görsel bilgini test et',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubCategoryScreen(
                            mainCategory: 'Fotoğraf',
                            categories: ['Genel Kültür', 'Futbol'],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CategoryCard(
                    icon: Icons.music_note,
                    title: 'Müzik',
                    subtitle: 'Müzik bilgini test et',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubCategoryScreen(
                            mainCategory: 'Müzik',
                            categories: ['Arabesk', 'Pop', 'Rap'],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CategoryCard(
                    icon: Icons.tv,
                    title: 'Dizi/Film',
                    subtitle: 'Sinema bilgini test et',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubCategoryScreen(
                            mainCategory: 'Dizi',
                            categories: ['Ezel', 'Kurtlar Vadisi'],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Center(
              child: Text(
                'Başlat — Bilgini sınayalım!',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
