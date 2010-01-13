Gem::Specification.new do |s|
  s.name        = %q{asset_hat}
  s.version     = %q{0.1.0}
  s.date        = %q{2010-01-05}

  s.authors     = ['Ron DeVera']
  s.email       = %q{ron@mintdigital.com}

  s.summary     = %q{Minify, bundle, and optimize CSS/JS assets.}
  s.homepage    = %q{http://github.com/mintdigital/asset_hat}
  s.description = %q{Your assets are covered.}
  s.files       = %w[README] + Dir.glob(File.join('{app,config,lib,public,rails,tasks,test}', '**', '*'))
  s.test_files  = Dir.glob(File.join('test', '**', '*'))

  s.rubyforge_project = %q{asset_hat}
  s.rubygems_version  = %q{1.3.5}
  s.add_development_dependency('shoulda', '>= 2.10.2')
  s.add_development_dependency('flexmock', '>= 0.8.6')
  s.add_runtime_dependency('cssmin', '>= 1.0.2')
  s.add_runtime_dependency('jsmin', '>= 1.0.1')
end
