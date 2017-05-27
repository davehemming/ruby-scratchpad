RSpec.describe 'string' do
  describe 'slice' do

    it 'performs a slice on a string' do

      expect('$.store.book'[0]).to eql('$')
      expect('$.store.book'[/[^.]*/]).to eql '$'
      expect('store.book'[/[^.]*/]).to eql 'store'
      expect('book'[/[^.]*/]).to eql 'book'
      expect('$.store.book'.slice(2, '$.store.book'.length)).to eql('store.book')
      expect('$.store.book'[/^.*?(\.|$)/]).to eql '$.'
      expect('book'[/^.*?(\.|$)/]).to eql 'book'
      expect(''[/^.*?(\.|$)/]).to eql ''
      expect('$.'.chop).to eql '$'

    end

    it 'performs a symbol conversion' do
      expect('book'.to_sym).to eql(:book)
    end
  end
end
