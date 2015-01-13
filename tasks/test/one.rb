namespace :test do
  desc "execute one of bundler versions"
  task :one do
    ver = ENV['ECOGEM_TEST_BUNDLER_VERSION']
    ::Kernel.__send__ :gem, 'bundler', "= #{ver}"
  end
end

