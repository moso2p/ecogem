RSpec.describe "basic example" do
  it "" do
    Dir.chdir(File.expand_path('../basic_example', __FILE__)) do |dir|
      Ecogem.new_workspace(nil) do |ws|
        gemfile = "--gemfile=#{ws.gemfile.write.inspect}"
        ws.gitsfile.save
        expect(File.read('Gemfile').strip).to eq(File.read('expected').strip)
      end
    end
  end
end