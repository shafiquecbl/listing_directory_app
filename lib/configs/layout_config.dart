class LayoutConfig {
  static String homePage = 'homepage';
  static String categoryPage = 'categoryPage';
  static String settingPage = 'settingPage';
  static String discoverPage = 'discoverPage';
  static String wishListPage = 'wishListPage';
  static String chatPage = 'chatPage';

  /// TODO: CHANGE YOUR LAYOUT (OPTIONAL)
  static Map<dynamic, dynamic> data = {
    'homeScreen': {
      'version': 'v2', // Currently support v1 and v2
      'images': [
        'https://imgur.com/v5l8VTq.jpg',
        'https://imgur.com/vynDJiW.jpg',
        'https://imgur.com/bibxWhj.jpg',
        'https://imgur.com/Sy1Xw6s.jpg'
      ],
      'layout': [
        {
          'listCategory': {
            // Currently support v1 and v2
            'type': 'icon',
            'version': 'v2',
            'list': [
              {
                'icon': 'https://imgur.com/bnegNwX.png',
                'id': 12,
              },
              {
                'icon': 'https://imgur.com/Q6DpptA.png',
                'id': 14,
              },
              {
                'icon': 'https://imgur.com/rG2F5Eu.png',
                'id': 16,
              },
              {
                'icon': 'https://imgur.com/XGTR3g0.png',
                'id': 37,
              },
              {
                'icon': 'https://imgur.com/G0Mi15x.png',
                'id': 57,
              },
              {
                'icon': 'https://imgur.com/bsbvOKr.png',
                'id': 54,
              },
              {
                'icon': 'https://imgur.com/tOS6mCo.png',
                'id': 58,
              },
              {
                'icon': 'https://imgur.com/ekzuEHz.png',
                'id': -1,
              }
            ],
          },
        },
        {
          'headerText': {
            'title': 'Featured Listings',
            'showSeeAll': false,
          }
        },
        {
          'adSliderBanner': {
            // Currently support v1, v2 and v3
            'uniqueId': 2,
            'version': 'v2',
            'adType': 'spotlight',
            'count': 3,
            'interval': 3,
            'autoPlay': true,
          }
        },
        {
          'headerText': {
            'title': 'Places you may like',
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
                'type': 'category',
                'version': 'v1',
                'ids': [14],
                'imageUrl':
                    'https://blogs.biomedcentral.com/on-medicine/wp-content/uploads/sites/6/2019/09/iStock-1131794876.t5d482e40.m800.xtDADj9SvTVFjzuNeGuNUUGY4tm5d6UGU5tkKM0s3iPk-620x342.jpg',
                'title': 'Asian'
              },
              {
                'type': 'listing',
                'version': 'v1',
                'id': 26,
                'imageUrl':
                    'https://blogs.biomedcentral.com/on-medicine/wp-content/uploads/sites/6/2019/09/iStock-1131794876.t5d482e40.m800.xtDADj9SvTVFjzuNeGuNUUGY4tm5d6UGU5tkKM0s3iPk-620x342.jpg',
                'title': 'Yahoo'
              },
              {
                'type': 'category',
                'version': 'v1',
                'ids': [14],
                'imageUrl':
                    'https://eatforum.org/content/uploads/2018/05/table_with_food_top_view_900x700.jpg',
                'title': 'Western Food'
              },
              {
                'type': 'listing',
                'version': 'v1',
                'id': 27,
                'imageUrl':
                    'https://blogs.biomedcentral.com/on-medicine/wp-content/uploads/sites/6/2019/09/iStock-1131794876.t5d482e40.m800.xtDADj9SvTVFjzuNeGuNUUGY4tm5d6UGU5tkKM0s3iPk-620x342.jpg',
                'title': 'Yamahaa'
              },
            ]
          },
        },
        {
          'headerText': {
            'title': 'Hot picks',
            'showSeeAll': false,
          }
        },
        {
          'sliderBanner': {
            // Currently support v1, v2 and v3
            'version': 'v2',
            'autoPlay': true,
            'interval': 3,
            'list': [
              {
                'type': 'category',
                'version': 'v1',
                'ids': [14],
                'imageUrl':
                    'https://blogs.biomedcentral.com/on-medicine/wp-content/uploads/sites/6/2019/09/iStock-1131794876.t5d482e40.m800.xtDADj9SvTVFjzuNeGuNUUGY4tm5d6UGU5tkKM0s3iPk-620x342.jpg',
                'title': 'Asian'
              },
              {
                'type': 'listing',
                'version': 'v1',
                'id': 28,
                'imageUrl':
                    'https://blogs.biomedcentral.com/on-medicine/wp-content/uploads/sites/6/2019/09/iStock-1131794876.t5d482e40.m800.xtDADj9SvTVFjzuNeGuNUUGY4tm5d6UGU5tkKM0s3iPk-620x342.jpg',
                'title': 'Yahoo'
              },
              {
                'type': 'category',
                'version': 'v1',
                'ids': [14],
                'imageUrl':
                    'https://eatforum.org/content/uploads/2018/05/table_with_food_top_view_900x700.jpg',
                'title': 'Western Food'
              },
              {
                'type': 'listing',
                'version': 'v1',
                'id': 29,
                'imageUrl':
                    'https://blogs.biomedcentral.com/on-medicine/wp-content/uploads/sites/6/2019/09/iStock-1131794876.t5d482e40.m800.xtDADj9SvTVFjzuNeGuNUUGY4tm5d6UGU5tkKM0s3iPk-620x342.jpg',
                'title': 'Yamahaa'
              },
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
            'headerText': 'Luxury Restaurants',
            'showSeeAll': true,
            'ids': [57],
            'limit': 5
          }
        },
        {
          'category': {
            'version': 'v1',
            'headerText': 'Lovely Malls',
            'showSeeAll': false,
            'ids': [60],
            'limit': 5
          },
        },
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
