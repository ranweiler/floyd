require.config
  baseUrl: '.'
  packages: [
    {
      name: 'app'
      location: 'js/app'
    }
    {
      name: 'vendor'
      location: 'js/vendor'
    }
  ]

  paths: {
    'jquery': '//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min'
  }

require ['jquery', 'app/ready'], ($, ready) ->
  $.ready ready
