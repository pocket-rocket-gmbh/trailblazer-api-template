RSpec.shared_examples "delete_bulk" do |model, scope|
  before(:all) do
    delete_json @endpoint, @delete_json, @token
  end

  if scope == 'allowed'
    it 'should return status 200' do
      expect(response.status).to eq 200
    end

    it 'should remove the records' do
      expect(model.where(id: @resources.pluck(:id)).count).to eq 0
    end

    it 'should return the correct result' do
      body = eval(response.body)
      expect(body[:total_rows_to_delete]).to eq @resources.pluck(:id).count
      expect(body[:successful_deletes]).to eq @resources.pluck(:id).count
      expect(body[:failed_deletes]).to eq 0
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