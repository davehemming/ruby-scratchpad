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

    if json_path.empty?
      if sub_path.start_with? '$'
        return hash_val
      else

        if sub_path.include?('[*]')
          key = sub_path[/[^\[]*/]
          hash_val[key.to_sym] = [value]
        else
          hash_val[sub_path.to_sym] = value
        end

        return hash_val

      end

    else
      if sub_path.start_with? '$'
        json_path_to_hash(json_path, value, hash_val)
      elsif sub_path.include?('[*]')
        key = sub_path[/[^\[]*/]
        hash_val[key.to_sym] = [json_path_to_hash(json_path, value)]
      else
        key = sub_path.end_with?('.') ? sub_path.chop : sub_path
        hash_val[key.to_sym] = json_path_to_hash(json_path, value)
      end
    end

    hash_val

  end

  def json_paths_to_hash(attributes)

    new_hash = {}

    attributes.each do |attribute|

      if attribute[:path].match(/\[\d\]/).nil?
        new_hash.deep_merge!(
            json_path_to_hash(attribute[:path], attribute[:value]),
            {merge_hash_arrays: true}
        )
      else

        new_hash.deep_merge!(
            json_path_to_hash(attribute[:path].gsub!(/\[\d\]/, '[*]'), attribute[:value])
        )
      end

    end

    new_hash

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
