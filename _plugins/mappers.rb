class SysDateMapper < ::Jekyll::Contentful::Mappers::Base
  def map
    result = super

    entry.sys.each do |k, v|
      name, value = map_field k, v
      result['sys'][name] = value if (name == 'createdAt' || name == 'updatedAt')
    end

    result
  end
end
