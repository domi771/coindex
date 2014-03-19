FactoryGirl.define do
  sequence :sn do |i|
    i.to_s
  end

  factory :id_document do
    name { Faker::Name.name }
    sn
    member
    category 1

    trait :verified do
      verified true
    end
  end
end
