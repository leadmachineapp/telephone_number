require "test_helper"

module TelephoneNumber
  class FormatterTest < Minitest::Test
    def test_formatted_national_number_returns_correctly_for_us
      telephone_number = TelephoneNumber.parse("3175082333", "US")
      assert_equal "(317) 508-2333", telephone_number.formatted_national_number
    end

    def test_formatted_national_number_returns_nil_if_number_is_invalid
      telephone_number = TelephoneNumber.parse("317508233312345678", "US")
      assert_nil telephone_number.formatted_national_number
    end

    def test_formatted_national_number_returns_correctly_for_uk
      telephone_number = TelephoneNumber.parse("07917599799", "GB")
      assert_equal "07917 599799", telephone_number.formatted_national_number
    end

    def test_formatted_national_number_returns_correctly_for_de
      telephone_number = TelephoneNumber.parse("01751850682", "DE")
      assert_equal "0175 1850682", telephone_number.formatted_national_number
    end

    def test_formatted_national_number_returns_correctly_for_au
      telephone_number = TelephoneNumber.parse("0467703037", "AU")
      assert_equal "0467 703 037", telephone_number.formatted_national_number
    end

    def test_formatted_national_number_returns_correctly_for_ca
      telephone_number = TelephoneNumber.parse("4164076148", "CA")
      assert_equal "(416) 407-6148", telephone_number.formatted_national_number
    end
  end
end
