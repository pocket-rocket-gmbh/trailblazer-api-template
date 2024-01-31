RSpec.shared_examples "plain" do |scope|
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