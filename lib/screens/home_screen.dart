import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_mvp/managers/home_manager.dart';
import 'package:mini_mvp/screens/product_screen.dart';
import 'package:provider/provider.dart';

import '../globals/theme/app_theme.dart';
import '../globals/widgets/app_bar.dart';
import '../globals/widgets/product_card.dart';
import '../managers/product_manager.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthenticationService>().userIdGetter;
    return Scaffold(
        appBar: CustomAppBar.customAppBar(
            leadingIcon: false,
            title: "Product Catalogue",
            context: context,
            color: AppTheme.subHeadingColor.withOpacity(0.08),
            action: [
              IconButton(
                  onPressed: () => context.read<AuthenticationService>().signOut(),
                  icon: const Icon(Icons.logout))
            ]),
        body: Consumer<HomeManager>(builder: (context, homeManager, child) {
          return RefreshIndicator(
            onRefresh: () async {
              homeManager.startProductBasketSubscription();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: homeManager.prodControl,
              child: Column(
                children: [
                  homeManager.productBasket.isEmpty
                      ? Text(
                          "Refresh to laod newly added products if you have less than 10 products",
                          style: GoogleFonts.openSans(
                              fontSize: 14,
                              color: AppTheme.subHeadingColor,
                              fontWeight: FontWeight.w600))
                      : Stack(children: [
                          ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: homeManager.productBasket.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
                                  child: ProductCard(
                                    productDescription:
                                        homeManager.productBasket[index].productDescription,
                                    price: homeManager.productBasket[index].productPrice.toString(),
                                    widget: Image(
                                      height: 100,
                                      width: 100,
                                      image: NetworkImage(
                                          homeManager.productBasket[index].productImage),
                                    ),
                                    productName: homeManager.productBasket[index].productName,
                                  ),
                                );
                              }),
                          homeManager.isLoading
                              ? Positioned.fill(
                                  child: Container(
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ]),
                  homeManager.productAvailable
                      ? const SizedBox()
                      : SizedBox(
                          child: Text(
                            "No More Products available, Refresh to laod newly added products if you have less than 10 products",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                                fontSize: 14,
                                color: AppTheme.subHeadingColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                          create: (_) => ProductManager(userId!),
                          child: const AddProductScreen(),
                        )));
          },
          label: Row(
            children: const [
              Icon(Icons.add),
              Text("  Add Products"),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
