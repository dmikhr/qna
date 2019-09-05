shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: {access_token: '1234'}, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'API response successful' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'returns list of items' do
  it 'returns list of items' do
    item_ids = items.map { |item| item.id }
    all_items_match = json_items.map { |item| item_ids.include?(item['id']) }
    expect(all_items_match.any?(false)).to be false
  end
end

shared_examples_for 'returns all public fields' do
  it 'returns all public fields' do
    json_items.zip(items).each do |json_item, item|
      public_fields.each do |attr|
        expect(json_item[attr]).to eq item.send(attr).as_json
      end
    end
  end
end
