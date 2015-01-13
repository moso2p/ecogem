require 'fileutils'
require 'tmpdir'

RSpec.describe "basic example" do
  it do
    dir = File.expand_path('../basic_example', __FILE__)
    Dir.mktmpdir(nil, dir) do |tmpdir|
      FileUtils.cp "#{dir}/Ecogemfile", "#{tmpdir}/Ecogemfile"
      Dir.chdir(tmpdir) do
        Ecogem.new_workspace(nil) do |ws|
          ws.gemfile.write
          expect(File.read("#{tmpdir}/Gemfile").strip).to eq(File.read("#{dir}/expected").strip)
        end
      end
    end
  end
end