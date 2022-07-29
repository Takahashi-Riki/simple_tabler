# frozen_string_literal: true

require_relative "simple_tabler/version"
require_relative "table_from_array"

class Array; include SimpleTabler; end

module SimpleTabler
  CORRECT_OBJECTS = [String, Numeric, Symbol, TrueClass, FalseClass]

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

    table_generated_from_array = TableFromArray.new(self, column_names, scale)
    return table_generated_from_array.content_of_table
  end

  # return true if dimension of array equal two.
  # ex. [["hoge", "fuga"], ["hoge", "fuga"]]
  #     => true
  #     [["hoge", "fuga"], ["hoge", "fuga", ["hoge"]]]
  #     => false
  def dimension_equal_two?
    self.each do |child_array|
      return false unless child_array.kind_of?(Array)
      return false unless child_array == child_array.flatten
    end
    return true
  end

  # return true if all of the child array has same length of item.
  # ex. [["1", "2"], ["1", "2"]]
  #     => true
  #     [["1", "2"], ["1", "2", "3"]]
  #     => false
  def child_array_size_same?
    child_array_sizes = self.map{|child_array| child_array.size}
    child_array_sizes.uniq.size == 1
  end

  # return true if all of array items are kind of CORRECT_OBJECTS.
  def element_type_correct?
    self.each do |child_array|
      child_array.each do |element|
        return false unless CORRECT_OBJECTS.any?{|object_type| element.kind_of?(object_type)}
      end
    end
    return true
  end

  # return true if array size and column size is same.
  def column_size_correct?(column_names)
    self[0].size == column_names.size
  end
end