class TableFromArray
  attr_reader :content_of_table, :column_names
  
  def initialize(column_size, column_names, scale)
    @content_of_table = ""
    @column_size      = column_size
    @column_names     = column_names
    @scale            = scale
  end

  def add_header
    if @column_names
      add_separation("=")
      add_row(@column_names)
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

  private
    def max_length_of_array_element(array)
      array.map{|element| element.to_s.size}.max
    end

    def add_row(row_materials)
      content_of_row  = ""
      number_of_lines = max_length_of_array_element(row_materials) / @scale + 1
      for i in 0...number_of_lines do
        line = "|"
        for row_material in row_materials do
          row_material_sliced_for_this_line = row_material[@scale*i...@scale*(i+1)].to_s
          space_to_fill_the_blank           = " " * (@scale - row_material_sliced_for_this_line.size)
          line                             += row_material_sliced_for_this_line + space_to_fill_the_blank + "|"
        end
        content_of_row += line + "\n"
      end
      @content_of_table += content_of_row
    end

    def add_separation(mark)
      separation         = "|" + mark * (@scale * @column_size + @column_size - 1) + "|" + "\n"
      @content_of_table += separation
    end
end