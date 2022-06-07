require 'rails_helper'

RSpec.describe "Potepan::Products", type: :request do
  let(:product_a) { create(:product) }

  before do
    get potepan_product_path(product_a.id)
  end

  describe '詳細ページテスト' do
    it "商品詳細ページから正常にレスポンスを返す" do
      expect(response).to have_http_status(200)
    end

    it '商品名が表示される' do
      expect(response.body).to include(product_a.name)
    end

    it '値段が表示される' do
      expect(response.body).to include(product_a.display_price.to_s)
    end

    it '説明が表示される' do
      expect(response.body).to include(product_a.description)
    end
  end
end
