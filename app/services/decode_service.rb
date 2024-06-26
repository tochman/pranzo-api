module DecodeService
  def self.attach_image(file, target, attribute)
    return unless file.is_a?(String) && file.start_with?('data:')

    image = split_base64_string(file)
    return if image[:data].blank?

    decoded_data = Base64.decode64(image[:data])
    io = StringIO.new
    io.puts(decoded_data)
    io.rewind
    target.method(attribute.to_sym).call.attach(io: io, filename: "attachment.#{image[:extension]}")
  end

  def self.split_base64_string(string)
    split_image_data = {}
    if string =~ /^data:(.*?);(.*?),(.*)$/
      split_image_data[:type] = Regexp.last_match(1)
      split_image_data[:encoder] = Regexp.last_match(2)
      split_image_data[:extension] = Regexp.last_match(1).split('/').last
      split_image_data[:data] = Regexp.last_match(3)
    end
    split_image_data
  end
end
