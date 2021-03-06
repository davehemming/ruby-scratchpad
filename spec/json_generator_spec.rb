require './src/json_generator'

RSpec.describe JsonGenerator do

  json_generator = JsonGenerator.new

  describe 'get_json' do

    it 'returns a hash' do

      result = json_generator.get_json

      expect(result).to be_a(Hash)

    end

  end

  describe 'get_assessment' do

    it 'returns an assessment' do

      result = json_generator.get_assessment

      expect(result).to include(customer: {
          firstName: 'David',
          lastName: 'Hemming'
      })

    end

  end

  describe 'modify_assessment' do

    it 'adds a string attribute to an assessment object' do

      modifier = {customer: {age: 35}}

      result = json_generator.modify_assessment(modifier)

      expect(result).to include(customer: {
          firstName: 'David',
          lastName: 'Hemming',
          age: 35
      })

    end

    it 'adds a new hash attribute to an assessment object' do
      modifier = {location: {city: 'Melbourne'}}

      result = json_generator.modify_assessment modifier

      expect(result).to include(
        customer: {
          firstName: 'David',
          lastName: 'Hemming'
        },
        location: {
            city: 'Melbourne'
        })
    end

    it 'adds a new value to an array' do
      modifier = {pets: json_generator.get_assessment[:pets].push('frog')}

      result = json_generator.modify_assessment modifier

      expect(result[:pets]).to include('dog', 'cat', 'bird', 'frog')
    end

    it 'deletes a string attribute from an assement object' do
      modifier = {customer: {lastName: :delete}}

      result = json_generator.modify_assessment modifier

      expect(result).to include({
          customer: {
              firstName: 'David'
          }
      })
    end

    it 'deletes a hash attribute from an assessment object' do
      modifier = {customer: :delete}

      result = json_generator.modify_assessment modifier

      expect(result[:customer]).to be_nil
    end

    it 'deletes a value from an array object' do

      pets_array = json_generator.get_assessment[:pets]
      pets_array.delete_at(pets_array.find_index {|v| v.eql? 'dog' })
      modifier = {pets: pets_array}

      result = json_generator.modify_assessment modifier

      expect(result[:pets]).to include('cat', 'bird')
    end
  end

  describe 'json_path_to_hash' do

    it 'takes a valid json path and value and returns a hash' do

      json_path_fixtures = [
          {
              path: '$.',
              value: nil,
              expecting: {}
          },
          {
              path: '$.book',
              value: 'David Hemming\'s Autobiography',
              expecting: {book: 'David Hemming\'s Autobiography'}
          },
          {
              path: '$.store.book',
              value: 'David Hemming\'s Autobiography',
              expecting: {store: {book: 'David Hemming\'s Autobiography'}}
          },
          {
              path: '$.staff[*]',
              value: 'Bob',
              expecting: {staff: ['Bob']}
          },
          {
              path: '$.store.staff[*].name',
              value: 'Bob',
              expecting: {store: {staff: [{name: 'Bob'}]}}
          },
          {
              path: '$.store.staff[*].scheduledDays',
              value: %w[SAT SUN MON],
              expecting: {store: {staff: [{scheduledDays: %w[SAT SUN MON]}]}}
          }
      ]

      json_path_fixtures.each do |fixture|
        result = json_generator.json_path_to_hash(fixture[:path], fixture[:value])
        expect(result).to match(fixture[:expecting])
      end

    end
  end

  describe 'json_paths_to_hash' do

    it 'takes a multiple valid json path and value and returns a hash' do

      json_path_fixtures = [
          {
              attributes: [
                  {
                      path: '$.book',
                      value: 'David Hemming\'s Autobiography'
                  },
                  {
                      path: '$.sales.total',
                      value: 2000
                  }
              ],
              expecting: {
                  book: 'David Hemming\'s Autobiography',
                  sales: {
                      total: 2000
                  }
              }
          },
          {
              attributes: [
                  {
                      path: '$.books[*]',
                      value: 'David Hemming\'s Autobiography'
                  },
                  {
                      path: '$.books[*]',
                      value: 'The Complete Idiots Guide To Fighting Squirrels'
                  }
              ],
              expecting: {
                  books: ['David Hemming\'s Autobiography','The Complete Idiots Guide To Fighting Squirrels']
              }
          },
          {
              attributes: [
                  {
                      path: '$.employees[*].name',
                      value: 'Fred'
                  },
                  {
                      path: '$.employees[*].age',
                      value: 22
                  },
                  {
                      path: '$.employees[*].phone',
                      value: '03 4444 3333'
                  }
              ],
              expecting: {
                  employees: [
                      {
                          name: 'Fred',
                          age: 22,
                          phone: '03 4444 3333'
                      }
                  ]
              }
          },
          {
              attributes: [
                  {
                      path: '$.employees[0].name',
                      value: 'Fred'
                  },
                  {
                      path: '$.employees[1].name',
                      value: 'Bill'
                  },
                  {
                      path: '$.employees[2].name',
                      value: 'Jane'
                  }
              ],
              expecting: {
                  employees: [
                      {name: 'Fred'},
                      {name: 'Bill'},
                      {name: 'Jane'}
                  ]
              }
          }
      ]

      json_path_fixtures.each do |fixture|
        result = json_generator.json_paths_to_hash(fixture[:attributes])
        expect(result).to match(fixture[:expecting])
      end

    end

  end

end
