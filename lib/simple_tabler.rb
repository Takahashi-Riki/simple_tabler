# frozen_string_literal: true

require_relative "simple_tabler/version"
require_relative "table_from_array"

class Array; include SimpleTabler; end

module SimpleTabler
  def dimension_equal_two?
    self.each do |child_array|
      if !child_array.kind_of?(Array)
        return false
      elsif child_array != child_array.flatten
        return false
      end
    end
    return true
  end

  def child_array_size_same?
    child_array_sizes = self.map{|child_array| child_array.size}
    child_array_sizes.uniq.size == 1
  end

  def element_type_correct?
    correct_object_types = [String, Numeric, Symbol, TrueClass, FalseClass]
    self.each do |child_array|
      child_array.each do |element|
        result_each_kind_of = correct_object_types.map{|object_type| element.kind_of?(object_type)}
        return false if !result_each_kind_of.include?(true)
      end
    end
    return true
  end

  def column_size_correct?(column_names)
    self[0].size == column_names.size
  end

  def generate_table(column_names=nil, scale=20)
    if !dimension_equal_two?
      raise ArgumentError, "The depth of array should be two."
    elsif !child_array_size_same?
      raise ArgumentError, "All child arrays should have same amount of element."
    elsif !element_type_correct?
      raise ArgumentError, "All child arrays should have elements which is kind of allowed class.\nAllowed class is String, Numeric, Symbol, TrueClass, FalseClass"
    elsif !column_names.nil? && !column_size_correct?(column_names)
      raise ArgumentError, "All child arrays should have same amount of element with column names you passed as an argument."
    end
    column_size                = self[0].size
    table_generated_from_array = TableFromArray.new(column_size, column_names, scale)
    table_generated_from_array.add_header
    table_generated_from_array.add_content(self)
    return table_generated_from_array.content_of_table
  end
end