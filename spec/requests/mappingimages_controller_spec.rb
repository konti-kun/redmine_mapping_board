require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')

describe MappingimagesController, type: :request do
  before do
    create :mappingboard, id: 0
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
