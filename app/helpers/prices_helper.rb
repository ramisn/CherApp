# frozen_string_literal: true

module PricesHelper
  PROPERTIES_PRICES = [nil, 50_000, 75_000, 100_000, 125_000, 150_000, 175_000, 200_000,
                       225_000, 250_000, 275_000, 300_000, 325_000, 350_000,
                       375_000, 400_000, 425_000, 450_000, 475_000, 500_000, 550_000,
                       600_000, 650_000, 700_000, 750_000, 800_000, 850_000,
                       900_000, 950_000, 1_000_000, 1_250_000, 1_500_000, 1_750_000,
                       2_000_000, 2_250_000, 2_750_000, 3_000_000, 3_250_000, 3_500_000,
                       3_750_000, 4_000_000, 4_250_000, 4_500_000, 4_750_000, 5_000_000,
                       6_000_000, 7_000_000, 8_000_000, 9_000_000, 10_000_000].freeze

  def valid_monthly_prices
    PROPERTIES_PRICES.map do |price|
      monthly_price = price.nil? ? nil : price / 100

      translation = formated_monthly_price(monthly_price)
      [translation, monthly_price]
    end
  end

  def valid_prices
    PROPERTIES_PRICES.map do |price|
      translation = formated_price(price)
      [translation, price]
    end
  end

  def formated_price(price)
    if price.nil? || price.zero?
      t('property_overview.price.any')
    elsif price < 1_000_000
      t('property_overview.price.k', price: price / 1_000)
    else
      sanitized_number = (price / 1_000_000.0).to_s.gsub('.0', '')
      t('property_overview.price.m', price: sanitized_number[0..3])
    end
  end

  def formated_monthly_price(monthly_price)
    if monthly_price.nil? || monthly_price.zero?
      t('property_overview.price.any')
    else
      t('placeholders.price') + monthly_price.to_s
    end
  end

  def history_sold_price(record)
    return '-' if record['amount']['saleamt'].zero?

    number_to_currency(record['amount']['saleamt'], locale: :en, precision: 0)
  end

  def down_payment(property_price, divide = 1)
    number_to_currency((property_price * 0.2) / divide, precision: 0)
  end

  def commission_value(price)
    number_to_currency(price * 0.025, locale: :en, precision: 0)
  end

  def history_message(record)
    sale_date = l(record['salesearchdate'].to_date, format: :month_and_year)
    return sale_date if record['amount']['saleamt'].zero?

    sold_price = number_to_currency(record['amount']['saleamt'], locale: :en, precision: 0)
    "#{sale_date}, Sold for #{sold_price}"
  end
end
