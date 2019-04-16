require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')

describe MappingimagesController, type: :request do
  before do
    create :mappingboard, id: 0
  end

  describe 'Get #get_images' do
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
      create :attachment, container_id: Mappingboard.find(0).project_id
      get '/mappingboards/0/mappingimages/get_images'
      expect(JSON(response.body)).to match([{"url"=>"/attachments/download/1/sample1.png"}])
    end

    it 'returns 2 urls' do
      create :attachment, container_id: Mappingboard.find(0).project_id
      create :attachment2, container_id: Mappingboard.find(0).project_id, author_id: User.first.id
      get '/mappingboards/0/mappingimages/get_images'
      result_json = [
        {"url"=>"/attachments/download/1/sample1.png"},
        {"url"=>"/attachments/download/2/sample2.jpg"},
      ]
      expect(JSON(response.body)).to match(result_json)
    end

  end

  describe 'Post #create' do               
    before do
      @params = attributes_for :mappingimage
    end
    it 'has a 200 status code' do
      post '/mappingboards/0/mappingimages', params: {mappingimage: @params}
      expect(response).to have_http_status(:ok)
    end

    it 'create one mappingimage' do
      post '/mappingboards/0/mappingimages', params: {mappingimage: @params}
      image = Mappingimage.first
      expect(image.url).to eq "/attachments/download/1/sample1.png"
      expect(image.x).to eq 0
      expect(image.y).to eq 0
      expect(image.width).to eq nil
      expect(image.height).to eq nil
    end

  end

end
