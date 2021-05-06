class LayoutConfig {
  static String homePage = 'homepage';
  static String categoryPage = 'categoryPage';
  static String settingPage = 'settingPage';
  static String discoverPage = 'discoverPage';
  static String wishListPage = 'wishListPage';
  static String chatPage = 'chatPage';

  static final String webBanner =
      'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/spainbanner4.jpg?alt=media&token=51443479-b141-4818-a212-ab800c97f9f7';

  /// TODO: CHANGE YOUR LAYOUT (OPTIONAL)
  static Map<dynamic, dynamic> data = {
    'homeScreen': {
      'version': 'v2', // Currently support v1 and v2
      'images': [webBanner, webBanner, webBanner, webBanner],
      'layout': [
        {
          'headerText': {
            'title': 'Categories',
            'showSeeAll': false,
          }
        },
        {
          'listCategory': {
            // Currently support v1 and v2
            'type': 'icon',
            'version': 'v2',
            'list': [
              {
                'icon': 'https://imgur.com/tOS6mCo.png',
                'id': 88,
              },
              {
                'icon':
                    'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/fast-food.png?alt=media&token=199af5d4-a9ab-4c1a-a067-3253eb49c7b9',
                'id': 326,
              },
              {
                'icon':
                    'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/hotel%20(1).png?alt=media&token=f1cbbe81-8e69-4e54-bff4-34aebaa7c8f8',
                'id': 40,
              },
              {
                'icon':
                    'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/online-shopping.png?alt=media&token=0e6d8d3c-0bab-4fde-a1f3-20f0e447a4c8',
                'id': 59,
              },
              // {
              //   'icon': 'https://imgur.com/ekzuEHz.png',
              //   'id': -1,
              // }
            ],
          },
        },
        {
          'headerText': {
            'title': 'Exclusive Listing',
            'showSeeAll': false,
          }
        },
        {
          'sliderBanner': {
            // Currently support v1, v2 and v3
            'version': 'v1',
            'autoPlay': true,
            'interval': 3,
            'list': [
              {
                'type': 'listing',
                'version': 'v1',
                'id': 1768,
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/empty.jpg?alt=media&token=5738247b-8a13-4374-a677-2ce704c61b02',
                'title': 'Automotive'
              },
              {
                'type': 'listing',
                'version': 'v1',
                'id': 1766,
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/empty.jpg?alt=media&token=5738247b-8a13-4374-a677-2ce704c61b02',
                'title': 'Essential Services'
              },
              {
                'type': 'listing',
                'version': 'v1',
                'id': 1763,
                'imageUrl':
                    'https://firebasestorage.googleapis.com/v0/b/thelista-7f00d.appspot.com/o/empty.jpg?alt=media&token=5738247b-8a13-4374-a677-2ce704c61b02',
                'title': 'Shopping'
              }
            ]
          },
        },
        {
          'category': {
            // Currently support v1 and v2
            'version': 'v2',
            'headerText': 'Nice Hotels',
            'showSeeAll': true,
            'ids': [40],
            'limit': 5
          }
        },
        {
          'category': {
            'version': 'v1',
            'headerText': 'TheLista Recommends...',
            'showSeeAll': true,
            'ids': [57],
            'limit': 5
          }
        }
      ],
    },
    'categoryScreen': {
      'version': 'v1', // Currently support v1
      'all': true,
      'allColor': 0xFF9966ff,
      'type': 'card',
      'enableBanner': true,
      'column': 2,
      'layout': [
        {
          'category': 12,
          'color': 0xFF9966ff,
        },
        {
          'category': 14,
          'color': 0xFFF082AC,
        },
        {
          'category': 16,
          'color': 0xFFF082AC,
        },
        {
          'category': 37,
          'color': 0xFFF082AC,
        },
        {
          'category': 40,
          'color': 0xFFF082AC,
        },
        {
          'category': 54,
          'color': 0xFFF082AC,
        },
        {
          'category': 57,
          'color': 0xFFF082AC,
        },
      ],
    },
    'discoverScreen': {
      'version': 'v2', // Currently support only v2
    },
    'wishListScreen': {
      'version': 'v1', // Currently support v1
    },
    'chatScreen': {
      'version': 'v1', // Currently support v1
    },
    'settingScreen': {
      'version': 'v1', // Currently support v1
    },
    'tabBar': {
      'version': 'v1', // Currently support v1
      'layout': [
        {
          'icon': 'https://imgur.com/12HNWdG.png',
          'page': 'homepage',
        },
        {
          'icon': 'https://imgur.com/uVIknaJ.png',
          'page': 'discoverPage',
        },
        {
          'icon': 'https://imgur.com/7obgaBr.png',
          'page': 'wishListPage',
        },
        {
          'icon': 'https://imgur.com/m9naL5y.png',
          'page': 'categoryPage',
        },
        {
          'icon': 'https://imgur.com/Zza0cAr.png',
          'page': 'chatPage',
        },
        {
          'icon': 'https://imgur.com/QZLGrhr.png',
          'page': 'settingPage',
        },
      ]
    },
    'onBoarding': {
      'version': 'v1', // Currently support v1
      'data': [
        {
          'url':
              'https://image.freepik.com/free-vector/chinese-street-restaurant-illustration_6138-76.jpg'
        },
        {
          'url':
              'https://i.pinimg.com/originals/12/d4/81/12d4810b9d25f866a98245e23c775351.jpg'
        },
        {
          'url':
              'https://image.freepik.com/free-vector/waiter-consumen-illustration-restaurant_111797-46.jpg'
        },
      ]
    },
    'other': {
      'searchScreen': {'version': 'v2'}, // Currently support v1 and v2
      'itemDetailScreen': {'version': 'v1'}, //Currently support  v1
    }
  };
}
