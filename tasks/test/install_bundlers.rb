namespace :test do
  desc "install all supported versions of bundler"
  task :install_bundlers do
    require_relative '../../lib/ecogem/version'
    Ecogem::BUNDLER_VERSIONS.each do |ver|
      system "gem install bundler -v #{ver} --no-rdoc --no-ri"
    end
  end
end

