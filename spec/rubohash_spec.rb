RSpec.describe Rubohash do
  it 'has a version number' do
    expect(Rubohash::VERSION).to eql('0.1.0')
  end

  describe 'concerning defaults' do
    it 'knows the default_extensions' do
      expect(Rubohash.default_extensions).to match_array(%w[.png .gif .jpg .bmp .jpeg .ppm .datauri])
    end

    it 'knows the default_set' do
      expect(Rubohash.default_set).to eql('set1')
    end

    it 'knows the use_default_set' do
      expect(Rubohash.use_default_set).to be_falsey
    end

    it 'knows the robot_output_path' do
      expect(Rubohash.robot_output_path).to eql('/Users/mark/dev/backend-tools/rubohash/output/')
    end

    it 'knows the default_format' do
      expect(Rubohash.default_format).to eql('png')
    end

    it 'knows the default_bg_set' do
      expect(Rubohash.default_bg_set).to eql('bg1')
    end

    it 'knows the use_default_bg_set' do
      expect(Rubohash.use_default_bg_set).to be_falsey
    end

    it 'knows the mounted' do
      expect(Rubohash.mounted).to be_falsey
    end
  end
end
