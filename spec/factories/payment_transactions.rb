# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :txid

  factory :payment_transaction do
    txid
    amount "9.99"
    address { Faker::Bitcoin.address }
  end
end
