#! /usr/bin/env ruby
#  encoding: UTF-8
#
#   check-uptime

Dir.chdir('.') do
  asset_home=File.expand_path("#{File.dirname(__FILE__)}/../")
  ENV["GEM_HOME"]="#{asset_home}/gem"
  if system("gem install --silent --no-user-install --install-dir $GEM_HOME bundler --version '~> 2'")
    system("#{asset_home}/rubyexec/#{File.basename($0)}") 
  else
    puts "Error installing bundler for #{File.basename($0)}"
    return 2  
  end
end


