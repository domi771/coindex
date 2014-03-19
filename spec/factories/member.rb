FactoryGirl.define do
  factory :member do
    email { Faker::Internet.email }
    name { Faker::Name.name }

    trait :activated do
      activated true
    end

    trait :verified do
      id_document { FactoryGirl.build :id_document, :verified }
    end
  end
end
