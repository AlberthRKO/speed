import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speed/components/contenedor.dart';
import 'package:speed/components/sidebar.dart';
import 'package:speed/controllers/sidebar_controller.dart';

class HomeDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<SidebarController>(
      init: SidebarController(),
      builder: (_) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            Sidebar(),
            ContenedorAnimado(
              isDrawerOpen: _.isDrawerOpen,
              xOffset: _.xOffset,
              yOffset: _.yOffset,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => _.abrirSidebar(size),
                          icon: Icon(
                            FontAwesomeIcons.bars,
                            size: 20,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        Text(
                          'Conductor',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        IconButton(
                          onPressed: () => _.abrirSidebar(size),
                          icon: Icon(
                            FontAwesomeIcons.ellipsisV,
                            size: 20,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
