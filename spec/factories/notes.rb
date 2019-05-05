FactoryBot.define do
  factory :note do
    association :issue, factory: :issue
  end
end
