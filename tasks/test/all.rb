namespace :test do
  desc "execute all tests"
  task :all do
    root = ::File.expand_path('../../..', __FILE__)
    require "#{root}/lib/ecogem/version"
    Ecogem::BUNDLER_VERSIONS.each do |ver|
      env = "ECOGEM_TEST_BUNDLER_VERSION=\"#{ver}\""
      exit false unless system("cd \"#{root}\";#{env} rspec ./spec/*")
    end
  end
end

