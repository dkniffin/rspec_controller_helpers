Gem::Specification.new do |s|
  s.name        = 'rspec_controller_helpers'
  s.version     = '0.0.1'
  s.date        = '2016-02-18'
  s.summary     = "Rails controller test helpers"
  s.description = "A few bits and pieces to make testing controllers easier"
  s.authors     = ["Derek Kniffin"]
  s.email       = 'derek.kniffin@gmail.com'
  s.files       = ["lib/rspec_controller_helpers.rb"]
  s.homepage    = 'https://github.com/dkniffin/rspec_controller_helpers'
  s.license     = 'MIT'
  s.add_runtime_dependency 'rspec-rails', '~> 3.0'
  s.add_runtime_dependency 'factory_girl_rails', '~> 4.0'
end
