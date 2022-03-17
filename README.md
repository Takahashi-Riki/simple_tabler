# Simple Tabler

Simple Tabler helps you to make a table in Terminal

## Installation

Add simple_tabler to your Gemfile.

```Gemfile
gem 'simple_tabler', '~> 0.1.0'
```

## Usage

First of all, you should read the module Simple Tabler.

```.rb
require "simple_tabler"
```

Now, you can create a table from an array like blow.

```.rb
a = [
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

puts a.generate_table(["Service", "username", "password"], 30)

#|============================================================================================|
#|Service                       |username                      |password                      |
#|============================================================================================|
#|ABCDE_Mail                    |example@example.com           |abcdefg_abcdefg_abcdefg_abcdef|
#|                              |                              |g_abcdefg_abcdefg_abcdefg_abcd|
#|                              |                              |efg_abcdefg_abcdefg_          |
#|--------------------------------------------------------------------------------------------|
#|XYZ_TV                        |Taro Yamada                   |qwertyqwertyqwertyqwertyqwerty|
#|                              |                              |qwertyqwertyqwertyqwertyqwerty|
#|                              |                              |                              |
#|--------------------------------------------------------------------------------------------|
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Takahashi-Riki/simple_tabler.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
