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
    # {
    #   name: 'vendor/jquery'
    #   location: '//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js'
    # }
    {
      name: 'jquery'
      location: 'https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js'
    }
    # {name: 'templates', location: 'templates'}
    # {name: 'load', location: 'js/load'}
    # {name: 'helpers', location: 'js/helpers'}
    # {name: 'routes', location: 'js/routes'}
    # {name: 'policy', location: 'js/policy'}
    # {name: 'middleware', location: 'js/policy/middleware'}
    # {name: 'components', location: 'components'}
  ]

  # map: '*':
  #   {'flight/component': 'js/vendor/flight/lib/component'}

# require ['vendor/jquery', 'app/ready'], ($, ready) ->
require ['jquery', 'app/ready'], ($, ready) ->
  alert 'hello'
  $.ready ready
