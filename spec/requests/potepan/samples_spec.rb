require 'rails_helper'

RSpec.describe "Potepan::Samples", type: :request do
  describe "トップページテスト" do
    it "正常にレスポンスを返す" do
      get potepan_path
      expect(response).to have_http_status(200)
    end
  end
end
