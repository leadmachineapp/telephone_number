require "test_helper"

module TelephoneNumber
  class ParserTest < Minitest::Test
    def setup
      @test_data = YAML.load_file("test/test.yml")
    end

    def test_sanitize_removes_all_non_numeric_characters
      numbers = %w(555$$@@5555555 ##$#%#5555555555)
      numbers.each do |number|
        telephone_number = TelephoneNumber.parse(number, "US")
        assert_equal '5555555555', telephone_number.sanitize(number)
      end
    end

    focus
    def test_extract_number_types_returns_local_and_e164_for_all_countries
      @test_data.each do |country, number_object|
        number_object.each do |name, number_data|
          comparison = [number_data[:national], number_data[:e164]]
          number_data.each do |type, number|
            telephone_number = TelephoneNumber.parse(number, country)
            binding.pry unless comparison ==  telephone_number.extract_number_types
            assert_equal comparison, telephone_number.extract_number_types
          end
        end
      end
    end

    # def test_extract_number_types_returns_local_and_e164_for_us
    #   us_local_numbers = %w(3175083345 13175083345)
    #   us_local_numbers.each do |number|
    #     telephone_number = TelephoneNumber.parse(number, "US")
    #     assert_equal us_local_numbers, telephone_number.extract_number_types
    #   end
    # end

    # def test_extract_number_types_returns_local_and_e164_for_gb
    #   uk_local_numbers = %w(07780991912 7780991912)
    #   uk_local_numbers.each do |number|
    #     telephone_number = TelephoneNumber.parse(number, "GB")
    #     assert_equal %w(7780991912 447780991912), telephone_number.extract_number_types
    #   end
    # end

    # def test_extract_number_types_returns_local_and_e164_for_in
    #   india_local_numbers = %w(09176642499 9176642499)
    #   india_local_numbers.each do |number|
    #     telephone_number = TelephoneNumber.parse(number, "IN")
    #     assert_equal %w(9176642499 919176642499), telephone_number.extract_number_types
    #   end
    # end

    # def test_extract_number_types_returns_local_and_e164_for_de
    #   german_local_numbers = %w(15222503070 015222503070)
    #   german_local_numbers.each do |number|
    #     telephone_number = TelephoneNumber.parse(number, "DE")
    #     assert_equal %w(15222503070 4915222503070), telephone_number.extract_number_types
    #   end
    # end

    def test_extract_number_types_returns_local_and_e164_when_number_is_invalid
      assert_equal %w(1305550029 11305550029), TelephoneNumber.parse("1305550029", "US").extract_number_types
      assert_equal %w(19222503070 4919222503070), TelephoneNumber.parse("19222503070", "DE").extract_number_types
    end

    ### VALIDATION TESTS #################################################

    def test_validate_us_numbers
      valid_us_numbers = %w(16502530000 14044879000 15123435283 13032450086 16175751300
                            13128404100 12485934000 19497941600 14257395600 13103106000
                            16086699600 12125650000 14123456700 14157360000 12068761800
                            12023461100)

      valid_us_numbers.each do |number|
        refute TelephoneNumber.parse(number, "US").validate.empty?
      end

      assert TelephoneNumber.parse("11305555555", "US").validate.empty?
    end

    def test_validate_uk_numbers
      valid_uk_numbers = %w(448444156790 442079308181 442076139800 442076361000
                            442076299400 442072227888)

      valid_uk_numbers.each do |number|
        refute TelephoneNumber.parse(number, "GB").validate.empty?
      end

      invalid_uk_numbers = %w(44987654321654 440844415679032)
      invalid_uk_numbers.each do |number|
        assert TelephoneNumber.parse(number, "GB").validate.empty?
      end
    end

    def test_validate_ca_numbers
      valid_ca_numbers = %w(16135550119 16135550171 16135550112 16135550194
                            16135550122 16135550131 15146708700 14169158200)

      valid_ca_numbers.each do |number|
        refute TelephoneNumber.parse(number, "CA").validate.empty?
      end
    end

    def test_validate_in_numbers
      valid_in_numbers = %w(915622231515 912942433300 912912510101 911126779191
                            912224818000 917462223999 912266653366 912266325757
                            914066298585 911242451234 911166566162 911123890606
                            911123583754 5622231515   2942433300   2912510101
                            1126779191   2224818000   7462223999   2266653366
                            2266325757   4066298585   1242451234   1166566162
                            1123890606   1123583754)

      valid_in_numbers.each do |number|
        refute TelephoneNumber.parse(number, "IN").validate.empty?
      end
    end

    def test_validate_with_invalid_country_returns_empty
      assert_equal TelephoneNumber.parse("1234567890", "NOTREAL").validate, []
    end
  end
end

