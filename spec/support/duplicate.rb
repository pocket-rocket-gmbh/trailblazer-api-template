RSpec.shared_examples "duplicate" do |model, scope|
  before(:all) do
    post_json @endpoint, @post_json, @token
  end

  if scope == 'allowed'
    it 'should return status 201' do
      expect(response.status).to eq 201
    end

    it 'should list the parsed body as hash' do
      expect(parsed_response.class).to eq Hash
    end

    it 'should output the duplicated data' do
      resource = parsed_response["resource"]
      old_model = model.find @resource.id
      new_model = model.find resource["id"]
      column_names = model.column_names
      column_names -= %w{id created_at updated_at}
      column_names.each do |col|
        if col == 'name'
          expect(new_model[col]).to eq @post_json[:name]
        elsif col != 'public_token'
          expect(new_model[col]).to eq old_model[col]
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
      if @expected_error_code
        expect(parsed_response['errors'][0]['code']).to eq @expected_error_code
      end
    end
  end
end