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
      expect('book[*]'[/^.*?(\.|$)/]).to eql 'book[*]'
      # expect('book[*].'[/^.*?(\.|$)/]).to eql 'book[*].'
      expect('book[*]'[/[^\[]*/]).to eql 'book'
      expect('book[*].'[/[^\[]*/]).to eql 'book'

    end

    it 'performs a symbol conversion' do
      expect('book'.to_sym).to eql(:book)
    end

    it 'performs a match' do
      expect('employee[0]'.match(/\[\d\]/)).to_not eql(nil)
    end

    it 'performs a gsub' do
      expect('employee[0].name'.gsub!(/\[\d\]/, '[*]')).to eql('employee[*].name')
    end
  end
end
