Gem::Specification.new do |s|

  s.name        = "admin_controller"
  s.version     = '0.0.1'
  s.authors     = ['Eric Anderson']
  s.email       = ['eric@pixelwareinc.com']

  s.files = Dir['lib/**/*.rb']
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'

  s.add_dependency 'rails'
  s.add_dependency 'responders'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'rake'
  
  s.summary     = 'Easy admin controllers'
  s.description = <<DESCRIPTION
Works basically like inherited resources except:

1. It is simpler. There are much fewer callbacks. If you need it to be
   more capable, your are better off just implement the controller
   without an abstraction library (possibly with the help of scaffolding
   and responders).
2. It is designed to use in admin controllers. This means:
   * There is no "show" action. After a create or update you go back to
     the list.
   * There is only a "form" template instead of both new and edit since
     those are almost the same and the differences can be handled better
     with conditionals.
3. It automatically uses many of the 'responders' modules available
   so flash is automatically set and caching is automatically used.
DESCRIPTION

end
