require 'rails_helper'

RSpec.describe "Potepan::Categories", type: :request do
  let(:taxon_a) { create(:taxon, name: 'taxon_a') }

  describe 'カテゴリーページテスト' do
    it "カテゴリーページから正常にレスポンスを返す" do
      get potepan_category_path(taxon_a.id)
      expect(response).to have_http_status(200)
    end
  end
end
