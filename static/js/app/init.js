// Generated by CoffeeScript 1.6.3
require.config({
  baseUrl: '.',
  packages: [
    {
      name: 'app',
      location: 'js/app'
    }, {
      name: 'vendor',
      location: 'js/vendor'
    }
  ],
  paths: {
    'jquery': '//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min'
  }
});

require(['jquery', 'app/ready'], function($, ready) {
  return $.ready(ready);
});