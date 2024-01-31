RSpec.shared_examples "list" do |scope, expected_results|
  before(:all) do
    get_json @endpoint, {}, @token
  end

  if scope == 'allowed'
    it 'should return status 200' do
      expect(response.status).to eq 200
    end

    it 'should list the parsed body as hash' do
      expect(parsed_response.class).to eq Hash
    end

    it 'should list the correct amount of expected results' do
      expect(parsed_response["total_results"]).to eq expected_results
    end

    it 'should output the correct data' do
      resources = parsed_response["resources"]
      resources.each do |resource|
        item = @model.find resource["id"]
        expect(@list).to include item
      end
    end

    it 'should include meta data in the parsed response' do
      expect(parsed_response["total_results"]).not_to eq nil
      expect(parsed_response["current_page"]).not_to eq nil
      expect(parsed_response["per_page"]).not_to eq nil
      expect(parsed_response["current_url"]).not_to eq nil
      expect(parsed_response["retrieved_at"]).not_to eq nil
    end
  end

  if scope == 'forbidden'
    it 'should return status 403' do
      expect(response.status).to eq 403
    end
  end

  if scope == 'not_found'
    it 'should return status 404' do
      expect(response.status).to eq 404
    end
  end
end