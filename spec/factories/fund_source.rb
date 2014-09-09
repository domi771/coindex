FactoryGirl.define do
  factory :fund_source do
    extra 'bitcoin'
    uid { Faker::Bitcoin.address }
    is_locked false
    currency 'btc'

    member { create(:member) }

    trait :chf do
      extra 'bank_code_1'
      uid '123412341234'
      currency 'chf'
    end

    factory :chf_fund_source, traits: [:chf]
    factory :btc_fund_source
  end
end

