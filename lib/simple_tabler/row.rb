class Row
  attr_reader :materials, :line_number, :scale

  def initialize(materials, line_number, scale)
    @materials   = materials
    @line_number = line_number
    @scale       = scale
  end

  def content
    materials.inject("|") do |content, material|
      string = material[scale*line_number...scale*(line_number+1)].to_s
      spaces = " " * (scale - string.size)
      content + string + spaces + "|"
    end
  end
end
