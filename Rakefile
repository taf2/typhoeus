require 'rake/clean'
require "spec"
require "spec/rake/spectask"

CLEAN.include 'ext/**/*.o'
CLEAN.include "ext/**/*.#{Config::MAKEFILE_CONFIG['DLEXT']}"
CLOBBER.include 'ext/**/*.log'
CLOBBER.include 'ext/**/Makefile'
CLOBBER.include 'ext/**/extconf.h'
MAKECMD = ENV['MAKE_CMD'] || 'make'
MAKEOPTS = ENV['MAKE_OPTS'] || ''
TYPHOEUS_SO = "ext/typhoeus/native.#{Config::MAKEFILE_CONFIG['DLEXT']}"
TYPHOEUS_FILES = (['ext/typhoeus/Makefile'] + Dir['ext/typhoeus/*.c'] + Dir['ext/typhoeus/*.h'])

# Make wrapper so gmake or nmake can be used
def make(target = '')
  Dir.chdir('ext/typhoeus') do
    pid = system("#{MAKECMD} #{MAKEOPTS} #{target}")
    $?.exitstatus
  end
end

file 'ext/typhoeus/Makefile' => 'ext/typhoeus/extconf.rb' do
  Dir.chdir('ext/typhoeus') do
    ruby "extconf.rb #{ENV['EXTCONF_OPTS']}"
  end
end

file TYPHOEUS_SO => TYPHOEUS_FILES do
  m = make
  fail "Make failed (status #{m})" unless m == 0
end

desc "Compile the shared object"
task :compile => [TYPHOEUS_SO]

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "\"#{File.dirname(__FILE__)}/spec/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

task :install, :compile do
  rm_rf "*.gem"
  puts `gem build typhoeus.gemspec`
  puts `sudo gem install typhoeus-#{Typhoeus::VERSION}.gem`
end

desc "Run all the tests"
task :default => [:compile, :spec]
