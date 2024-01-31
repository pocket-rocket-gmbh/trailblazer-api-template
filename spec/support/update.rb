RSpec.shared_examples "update" do |scope|
  before(:all) do
    put_json @endpoint, @put_json, @token
  end

  if scope == 'allowed'
    it 'should return status 200' do
      if response.status != 200 && response.parsed_body["errors"]
        puts " XXXXXXX SPEC ERROR XXXXXXX"
        puts response.parsed_body["errors"]
      end

      expect(response.status).to eq 200
    end

    it 'should list the parsed body as hash' do
      expect(parsed_response.class).to eq Hash
    end

    it 'should update the sent data' do
      resource = parsed_response["resource"]

      resource.keys.each do |key|
        if @put_json[key.to_sym]
          expect(resource[key]).to eq @put_json[key.to_sym]
        end
      end
    end

    it 'should include meta data in the parsed response' do
      expect(parsed_response["resource_url"]).not_to eq nil
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

  if scope == 'not_valid'
    it 'should return status 422' do
      expect(response.status).to eq 422
    end

    it 'should throw an error' do
      expect(parsed_response['errors'][0]['code']).to eq @expected_error_code
    end
  end
end