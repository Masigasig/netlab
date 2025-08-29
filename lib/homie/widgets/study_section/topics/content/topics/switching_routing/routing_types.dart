import '../../models/content_block.dart';

class RoutingTypesContent implements ModuleContent {
  @override
  String get moduleId => 'sr_route_types';

  @override
  List<ContentBlock> getContent() {
    return [
      ContentBlock(
        type: ContentBlockType.header,
        title: 'Route Types and Creation',
        content: '',
      ),
      ContentBlock(
        type: ContentBlockType.paragraph,
        content:
            '  Routers do not magically know about every network in existence. '
            'Instead, their routing tables are filled using three main methods: directly connected routes, static routes, and dynamic routes. '
            'Each method serves a different purpose, and together they allow routers to build a complete picture of how to reach different networks.',
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'Directly Connected Route',
            'definition':
                '  This is automatically created whenever a router is physically connected to a network. '
                'If a router has an interface plugged into a network and is assigned an IP address in that network’s address space, '
                'the router immediately knows that network exists and adds an entry for it in the routing table.'
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/direct_connected.png',
        title: 'Directly connected route example',
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'Static Route',
            'definition':
                '  A static route is created when a network administrator manually tells the router how to reach a particular network. '
                'This is like leaving written instructions in the router’s map: “If you want to reach Network X, send the packet to Router Y.” '
                'Static routes are useful in smaller networks with simple, stable connections. '
                'However, they require manual setup and maintenance. If the network changes, the administrator must update or remove the static routes to avoid sending packets into a dead end.'
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/static_route.png',
        title: 'Static route configuration example',
      ),
      ContentBlock(
        type: ContentBlockType.definition,
        content: [
          {
            'term': 'Dynamic Route',
            'definition':
                '  Dynamic routes are created when routers automatically exchange information about the networks they know. '
                'Instead of requiring a person to configure them, the routers essentially “talk” to each other and share their maps of the network. '
                'This makes dynamic routing highly scalable for large or constantly changing networks, such as the internet.'
          },
        ],
      ),
      ContentBlock(
        type: ContentBlockType.image,
        content: 'assets/images/content_image/dynamic_route.png',
        title: 'Dynamic routing exchange example',
      ),
      ContentBlock(
        type: ContentBlockType.note,
        content:
            '  Static routes are simple and reliable for small networks, while dynamic routes scale better for larger, changing networks.',
      ),
    ];
  }
}
