unless Rails.env.test?
  Operation.create(name: 'GeoScore')
end
