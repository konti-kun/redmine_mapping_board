require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')

describe MappingattachementimagesController, type: :request do
  before do
    create :mappingboard, id: 0
  end

  describe 'Get #index' do
    it 'has a 200 status code' do
      get '/mappingattachementimages?project_id=mappingboard_test'
      expect(response).to have_http_status(:ok)
    end

    it 'is json' do
      get '/mappingattachementimages?project_id=mappingboard_test'
      expect(response.content_type).to eq 'application/json'
    end

    it 'returns empty' do
      get '/mappingattachementimages?project_id=mappingboard_test'
      expect(response.body).to eq '[]'
    end

    it 'returns one url' do
      create :attachment, container_id: Mappingboard.find(0).project_id
      get '/mappingattachementimages?project_id=mappingboard_test'
      expect(JSON(response.body)).to match([{"url"=>"/mappingattachementimages/1"}])
    end

    it 'returns 2 urls' do
      create :attachment, container_id: Mappingboard.find(0).project_id
      create :attachment2, container_id: Mappingboard.find(0).project_id, author_id: User.first.id
      get '/mappingattachementimages?project_id=mappingboard_test'
      result_json = [
        {"url"=>"/mappingattachementimages/1"},
        {"url"=>"/mappingattachementimages/2"},
      ]
      expect(JSON(response.body)).to match(result_json)
    end

  end

end
