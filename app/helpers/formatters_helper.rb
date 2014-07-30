module FormattersHelper
  def format_percentage(number, precision = 2)
    number_to_percentage number, precision: precision, format: '%n %'
  end
end
