FactoryBot.define do
  factory :project do
    identifier { 'mappingboard_test' }
    name {'mappingboard_test'}
  end

  factory :user do
    mail { 'test@local.test' }
    login { 'test_login' } 
    firstname { 'test_first' }
    lastname { 'test_last'}
  end

  factory :attachment do
    association :author, factory: :user
    container_type { 'Project' }
    file { Rack::Test::UploadedFile.new(Rails.root.join(File.dirname(__FILE__) + '/../', 'fixtures/images', 'sample1.png'), 'image/png')  } 
  end
  factory :attachment2, class: Attachment do
    container_type { 'Project' }
    file { Rack::Test::UploadedFile.new(Rails.root.join(File.dirname(__FILE__) + '/../', 'fixtures/images', 'sample2.jpg'), 'image/jpg')  } 
  end

end
