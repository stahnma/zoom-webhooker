require "bundler/setup"
require 'yaml'


desc "Run dev app"
task :app do
  if ! ENV['ZOOM_SECRET']
    puts "You need to have ZOOM_SECRET set."
    exit 1
  end
  sh "bundle exec ruby app/router.rb"
end
