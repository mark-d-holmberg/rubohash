RSpec.describe Rubohash::Factory do
  describe 'concerning remove_extensions' do
    it 'removes extensions for all the specified extensions' do
      Rubohash.default_extensions.map { |k| "file#{k}" }.each do |_string|
        expect(described_class.new('file').remove_extensions('file')).to eql('file')
      end
    end

    it 'does not remove extensions if they are not white listed' do
      expect(described_class.new('file.com').remove_extensions('file.com')).to eql('file.com')
    end
  end

  describe 'concerning make_digest' do
    it 'makes the proper SHA512 digest' do
      # Digest::SHA512.hexdigest("mark.holmberg@icentris.com")
      expected = '292f165b46baaccc8032433344f9e3b4a267fcfac281af09e8fcdaeb128264757be7c96c36dc50bf80c8da25f9ebcef23141581fe54e6623b6154f8bf2799a97'
      expect(described_class.new('mark.holmberg@icentris.com').my_digest).to eql(expected)
    end
  end

  describe 'concerning create_hashes' do
    it 'splits them up properly' do
      expected = [2_830_138_455_147, 11_737_281_606_211, 3_523_208_952_650, 2_645_649_179_265, 12_028_568_653_230, 12_174_124_938_619, 15_928_268_123_589, 822_499_400_229, 17_174_449_038_100, 1_478_003_871_334, 2_454_059_284_671]
      expect(described_class.new('mark.holmberg@icentris.com').my_hash_array).to match_array(expected)
    end
  end
end
