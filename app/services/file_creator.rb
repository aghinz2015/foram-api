class FileCreator
  attr_reader :data, :format

  def initialize(data, format: :csv)
    @data = data
    @format = format
  end

  def file
    @file ||= begin
      file = Tempfile.new 'forams', path
      file.write data.send("to_#{format}")
      file.close
      file
    end
  end

  def content_type
    case format
    when :csv then 'text/csv'
    else 'text/plain'
    end
  end

  private

  def path
    @path ||= begin
      path = '/tmp/foram_api/forams'
      FileUtils.mkdir_p path unless File.exists? path
      path
    end
  end
end
