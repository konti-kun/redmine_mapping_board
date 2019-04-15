require 'rails_helper'

describe MappingimagesController, type: :request do
  describe 'Get #get_images' do
    before do
      create :mappingboard, id: 0
    end
    it 'has a 200 status code' do
      get '/mappingboards/0/mappingimages/get_images'
      expect(response).to have_http_status(:ok)
    end
    
    it 'is json' do 
      get '/mappingboards/0/mappingimages/get_images'
      expect(response.content_type).to eq 'application/json'
    end

    it 'returns empty' do
      get '/mappingboards/0/mappingimages/get_images'
      expect(response.body).to eq '[]'
    end

    it 'returns one url' do
      create :attachment, container_id: Project.first.id
      get '/mappingboards/0/mappingimages/get_images'
      expect(JSON(response.body)).to match([{"url"=>"/attachments/download/1/sample1.png"}])
    end

    it 'returns 2 urls' do
      create :attachment, container_id: Project.first.id
      create :attachment2, container_id: Project.first.id, author_id: User.first.id
      get '/mappingboards/0/mappingimages/get_images'
      result_json = [
        {"url"=>"/attachments/download/1/sample1.png"},
        {"url"=>"/attachments/download/2/sample2.jpg"},
      ]
      expect(JSON(response.body)).to match(result_json)
    end

  end

end
