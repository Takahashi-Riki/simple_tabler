class Separation
  attr_reader :mark, :cell_size, :scale

  def initialize(mark, cell_size, scale)
    @mark      = mark
    @cell_size = cell_size
    @scale     = scale
  end

  def content
    "|" + mark * (scale * cell_size + cell_size - 1) + "|"
  end
end
