# frozen_string_literal: true

RSpec.describe SimpleTabler do
  it "has a version number" do
    expect(SimpleTabler::VERSION).not_to be nil
  end

  let(:array_can_generate_table){
    [
      [
        "ABCDE_Mail",
        "example@example.com",
        "abcdefg_" * 10
      ],
      [
        "XYZ_TV",
        "Taro Yamada",
        "qwerty" * 10
      ]
    ]
  }

  context "#dimension_equal_two?" do
    let(:array_depth_1){
      ["aaa", "bbb", "ccc"]
    }
    let(:array_depth_2){
      [
        ["aaa", "bbb", "ccc"],
        ["ddd", "eee", "fff"],
        ["ggg", "hhh", "iii"],
      ]
    }
    let(:array_depth_3){
      [
        ["aaa", "bbb", ["ccc1", "ccc2", "ccc3"]],
        ["ddd", "eee", "fff"],
        ["ggg", "hhh", "iii"],
      ]
    }
    example "if array depth is 1." do
      expect(array_depth_1.dimension_equal_two?).to be_falsey
    end
    example "if array depth is 2." do
      expect(array_depth_2.dimension_equal_two?).to be_truthy
    end
    example "if array depth is more than 3." do
      expect(array_depth_3.dimension_equal_two?).to be_falsey
    end
  end

  context "#child_array_size_same?" do
    let(:array_same_child_size){
      [
        ["aaa", "bbb", "ccc"],
        ["ddd", "eee", "fff"],
        ["ggg", "hhh", "iii"],
      ]
    }
    let(:array_diffrent_child_size){
      [
        ["aaa", "bbb", "ccc"],
        ["ddd", "eee", "fff", "xxx"],
        ["ggg", "hhh", "iii"],
      ]
    }
    example "if child array sizes are same." do
      expect(array_same_child_size.child_array_size_same?).to be_truthy
    end
    example "if child array size are not same" do
      expect(array_diffrent_child_size.child_array_size_same?).to be_falsey
    end
  end

  context "#element_type_correct?" do
    let(:array_element_type_correct){
      [
        ["xxx", 111, :aaa],
        ["yyy", true, false]
      ]
    }
    let(:array_element_type_not_correct){
      [
        ["xxx", 111, [:aaa]],
        ["yyy", true, Time.now]
      ]
    }
    example "if element types are correct." do
      expect(array_element_type_correct.element_type_correct?).to be_truthy
    end
    example "if element types are not correct." do
      expect(array_element_type_not_correct.element_type_correct?).to be_falsey
    end
  end

  context "#column_size_correct?" do
    let(:column_names_size_3){
      ["header1", "header2", "header3"]
    }
    let(:column_names_size_4){
      ["header1", "header2", "header3", "header4"]
    }
    example "case Array size 3 and Column Names size 3." do
      expect(array_can_generate_table.column_size_correct?(column_names_size_3)).to be_truthy
    end
    example "case Array size 3 and Column Names size 4." do
      expect(array_can_generate_table.column_size_correct?(column_names_size_4)).to be_falsey
    end
  end

  context "#generate_table" do
    context "should raise error." do
      #Already tested each method, so we only test that this method can raise an error.
      let(:array_should_raise_error){
        [
          ["xxx", 111, [:aaa]],
          ["yyy", true, Time.now]
        ]
      }
      example "case it should raise error" do
        expect{array_should_raise_error.generate_table}.to raise_error(ArgumentError)
      end
    end

    context "should create a table properly" do
      let(:column_names){
        ["Service", "username", "password"]
      }
      let(:table_column_names_30){
        <<~TEXT
          |============================================================================================|
          |Service                       |username                      |password                      |
          |============================================================================================|
          |ABCDE_Mail                    |example@example.com           |abcdefg_abcdefg_abcdefg_abcdef|
          |                              |                              |g_abcdefg_abcdefg_abcdefg_abcd|
          |                              |                              |efg_abcdefg_abcdefg_          |
          |--------------------------------------------------------------------------------------------|
          |XYZ_TV                        |Taro Yamada                   |qwertyqwertyqwertyqwertyqwerty|
          |                              |                              |qwertyqwertyqwertyqwertyqwerty|
          |--------------------------------------------------------------------------------------------|
        TEXT
      }
      let(:table_nil_40){
        <<~TEXT
          |--------------------------------------------------------------------------------------------------------------------------|
          |ABCDE_Mail                              |example@example.com                     |abcdefg_abcdefg_abcdefg_abcdefg_abcdefg_|
          |                                        |                                        |abcdefg_abcdefg_abcdefg_abcdefg_abcdefg_|
          |--------------------------------------------------------------------------------------------------------------------------|
          |XYZ_TV                                  |Taro Yamada                             |qwertyqwertyqwertyqwertyqwertyqwertyqwer|
          |                                        |                                        |tyqwertyqwertyqwerty                    |
          |--------------------------------------------------------------------------------------------------------------------------|
        TEXT
      }
      let(:table_column_names_20){
        <<~TEXT
          |==============================================================|
          |Service             |username            |password            |
          |==============================================================|
          |ABCDE_Mail          |example@example.com |abcdefg_abcdefg_abcd|
          |                    |                    |efg_abcdefg_abcdefg_|
          |                    |                    |abcdefg_abcdefg_abcd|
          |                    |                    |efg_abcdefg_abcdefg_|
          |--------------------------------------------------------------|
          |XYZ_TV              |Taro Yamada         |qwertyqwertyqwertyqw|
          |                    |                    |ertyqwertyqwertyqwer|
          |                    |                    |tyqwertyqwertyqwerty|
          |--------------------------------------------------------------|
        TEXT
      }
      let(:table_nil_20){
        <<~TEXT
          |--------------------------------------------------------------|
          |ABCDE_Mail          |example@example.com |abcdefg_abcdefg_abcd|
          |                    |                    |efg_abcdefg_abcdefg_|
          |                    |                    |abcdefg_abcdefg_abcd|
          |                    |                    |efg_abcdefg_abcdefg_|
          |--------------------------------------------------------------|
          |XYZ_TV              |Taro Yamada         |qwertyqwertyqwertyqw|
          |                    |                    |ertyqwertyqwertyqwer|
          |                    |                    |tyqwertyqwertyqwerty|
          |--------------------------------------------------------------|
        TEXT
      }
      example "case contain columns names and scale is 30" do
        table_from_array = array_can_generate_table.generate_table(column_names, 30)
        expect(table_from_array).to eq table_column_names_30
      end
      example "case NOT contain columns names and scale is 40" do
        table_from_array = array_can_generate_table.generate_table(nil, 40)
        expect(table_from_array).to eq table_nil_40
      end
      example "case contain columns names and scale is not desinated" do
        table_from_array = array_can_generate_table.generate_table(column_names)
        expect(table_from_array).to eq table_column_names_20
      end
      example "case NOT contain columns names and scale is not desinated" do
        table_from_array = array_can_generate_table.generate_table()
        expect(table_from_array).to eq table_nil_20
      end
    end
  end
end