shared_examples_for 'error handler' do |code, message|
  it "responds with status code #{code}" do
    expect(response).to have_http_status code
  end

  it 'responds with proper error message' do
    expected_error_message = { error: message }
    expect(json_response).to eq expected_error_message
  end
end
