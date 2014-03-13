# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :address_index

  factory :payment_address do
    address { Faker::Bitcoin.address }
    currency { Currency.codes[:btc] }
    address_index
  end
end
