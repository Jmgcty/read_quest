import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_assets.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/utils/formatter.dart';
import 'package:read_quest/features/home/provider/get_current_user.dart';

class ReaderHomeScreen extends StatelessWidget {
  const ReaderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: size.height / 40),
        child: Column(
          children: [
            IntroductionSection(),
            Gap(size.height / 40),
            ShortCutSection(),
            Gap(size.height / 40),
            ReadingHistory(),
            Gap(size.height / 40),
            RecommendedBookSection(),
          ],
        ),
      ),
    );
  }
}

class IntroductionSection extends ConsumerStatefulWidget {
  const IntroductionSection({super.key});

  @override
  ConsumerState<IntroductionSection> createState() =>
      _IntroductionSectionState();
}

class _IntroductionSectionState extends ConsumerState<IntroductionSection> {
  @override
  Widget build(BuildContext context) {
    final currentMember = ref.watch(getCurrentMemberProvider).value;
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(left: size.width / 18, right: size.width / 18),
      child: Container(
        width: size.width,
        height: size.height / 6,
        decoration: BoxDecoration(
          color: AppColors.primaryDarkBlue,
          borderRadius: BorderRadius.circular(AppBorderSettings.borderRadius),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: Container(
                width: size.width / 1.4,
                padding: EdgeInsets.all(size.width / 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${currentMember?.user.name != null ? formatNameToGivenNameOnly(currentMember!.user.name) : 'Name👋'}',
                      style: theme.textTheme.headlineLarge!.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width / 12,
                      ),
                    ),
                    Gap(size.height / 80),
                    Text(
                      'Ready for your next reading adventure?',
                      style: theme.textTheme.headlineSmall!.copyWith(
                        fontSize: size.width / 18,
                        color: AppColors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            ),
            // Positioned Image inside the container
            Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              child: Image.asset(
                AppAssets.birdSayHello,
                scale: size.width / 140,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShortCutSection extends StatelessWidget {
  const ShortCutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 18),
      child: Row(
        children: [
          shortcutTile(
            context,
            title: 'Grade 5 Learner',
            icon: Icons.book,
            onTap: () {},
          ),
          Gap(size.width / 34),
          shortcutTile(
            context,
            title: 'Quizzes Passed',
            icon: Icons.quiz,
            onTap: () {},
          ),
          Gap(size.width / 34),
          shortcutTile(
            context,
            title: 'Badges Earned',
            icon: Icons.stars_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget shortcutTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: size.height / 12,
          padding: EdgeInsets.all(size.width / 60),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(AppBorderSettings.borderRadius),
          ),
          child: Row(
            children: [
              Icon(icon, size: size.width / 12, color: AppColors.primary),
              Gap(size.width / 50),
              // Wrap the Text widget in an Expanded widget to allow wrapping
              Expanded(
                child: Text(
                  title,
                  softWrap: true,
                  overflow: TextOverflow
                      .clip, // Optional: Adds an ellipsis if the text is too long
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: AppColors.textLabel,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width / 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReadingHistory extends StatelessWidget {
  const ReadingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.width / 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label(context),
          Gap(size.height / 80),
          ReadingHistorySection(),
        ],
      ),
    );
  }

  Widget label(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          'Reading History',
          style: theme.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textLabel,
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            'View All',
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.secondary,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

class ReadingHistorySection extends StatelessWidget {
  const ReadingHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height / 8,
      width: size.width,
      child: CarouselSlider.builder(
        itemCount: 6,
        itemBuilder: (context, index, realIndex) {
          return readingHistoryTile(context);
        },
        options: CarouselOptions(
          viewportFraction: 1,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          autoPlay: false,
          scrollDirection: Axis.horizontal,
          initialPage: 0,
        ),
      ),
    );
  }

  Widget readingHistoryTile(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(size.width / 40),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppBorderSettings.borderRadius),
      ),
      child: Row(
        children: [
          Container(
            width: size.width / 4,
            height: size.height / 8,
            color: AppColors.disabled,
            child: Icon(Icons.book, color: AppColors.white),
          ),
          Gap(size.width / 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Title',
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: size.width / 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                // Gap(size.height / 40),
                Text(
                  'Author Name',
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: size.width / 30,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textLabel,
                  ),
                ),

                Gap(size.height / 60),
                Text(
                  'You have read'
                  ' 50%'
                  ' of this book.',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontSize: size.width / 28,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedBookSection extends StatelessWidget {
  const RecommendedBookSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: size.width / 18,
        vertical: size.width / 40,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderSettings.borderRadius),
        color: AppColors.backgroundWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Recommended Books',
            style: theme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textLabel,
            ),
          ),
          Gap(size.height / 40),
          RecommendedBook(),
          TextButton(
            onPressed: () {},
            child: Text(
              'View All',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.secondary,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedBook extends StatelessWidget {
  const RecommendedBook({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CardItem(index: 0),
          CardItem(index: 1),
          CardItem(index: 2),
          CardItem(index: 3),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final int index;
  const CardItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width / 80),
      child: Stack(
        children: [
          Container(
            width: size.width / 2.5,
            height: size.height / 3.5,
            color: AppColors.disabled,
            child: Icon(Icons.book, color: AppColors.white),
          ),

          Container(
            width: size.width / 2.5,
            height: size.height / 3.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          Positioned(
            left: 6,
            bottom: 6,
            child: Text(
              'Book Title',
              style: theme.textTheme.headlineSmall!.copyWith(
                fontSize: size.width / 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),

          Positioned(
            top: 6,
            left: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                color: AppColors.primary,
                child: Text(
                  '10',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
