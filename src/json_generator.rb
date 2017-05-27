require 'json'
require 'deep_merge'

class JsonGenerator

  def get_json
    return {}
  end

  def get_assessment
    file = File.read('./resources/assessment.json')

    assessment = JSON.parse(file, symbolize_names: true)

  end

  def modify_assessment(modifier)

    assessment = get_assessment

    assessment.deep_merge!(modifier)

    remove_attributes(assessment)

    assessment

  end

  def json_path_to_hash(json_path, value, hash_val={})

    sub_path = json_path[/^.*?(\.|$)/]
    json_path = json_path.slice(sub_path.length, json_path.length)

    if json_path.length == 0
      hash_val[sub_path.to_sym] = value
      hash_val
    else
      if sub_path.eql? '$.'
        json_path_to_hash(json_path, value, hash_val)
      else
        hash_val[sub_path.chop.to_sym] = json_path_to_hash(json_path, value)
      end
    end

    hash_val

  end

  private
  def remove_attributes(a_hash)

    a_hash.each do |key, value|

      if value.kind_of? Hash
        remove_attributes(value)
      end

      if value.eql? :delete
        a_hash.delete key
      end
    end
  end

end
