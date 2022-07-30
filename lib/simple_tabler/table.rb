require_relative "row"
require_relative "separation"

class Table
  attr_accessor :content_array_of_table
  attr_reader :cell_size, :scale

  def initialize(array, column_names, scale)
    @content_array_of_table = []
    @cell_size = array[0].size
    @scale  = scale
    add_header(column_names)
    add_content(array)
  end

  def content
    self.content_array_of_table.inject(""){|result, content| result + content + "\n" }
  end

  private
    def add_row(row_materials)
      number_of_lines = (max_length_of_array_element(row_materials).to_f / scale).ceil
      (0...number_of_lines).each do |i|
        row = Row.new(row_materials, i, @scale)
        self.content_array_of_table << row.content
      end
    end

    def max_length_of_array_element(array)
      array.map{|element| element.to_s.size}.max
    end

    def add_header(column_names=nil)
      if column_names
        add_separation("=")
        add_row(column_names)
        add_separation("=")
      else
        add_separation("-")
      end
    end

    def add_content(table_materials)
      table_materials.each do |row_materials|
        add_row(row_materials)
        add_separation("-")
      end
    end

    def add_separation(mark)
      separation = Separation.new(mark, cell_size, scale)
      self.content_array_of_table << separation.content
    end
end
