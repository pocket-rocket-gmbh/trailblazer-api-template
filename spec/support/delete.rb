RSpec.shared_examples "delete" do |model, scope|
  before(:all) do
    delete_json @endpoint, @put_json, @token
  end

  if scope == 'allowed'
    it 'should return status 204' do
      if response.status != 204 && response.parsed_body["errors"]
        puts " XXXXXXX SPEC ERROR XXXXXXX"
        puts response.parsed_body["errors"]
      end

      expect(response.status).to eq 204
    end

    it 'should remove the record' do
      expect(model.find_by(id: @resource.id)).to eq nil
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