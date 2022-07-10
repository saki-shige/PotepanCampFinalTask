require 'rails_helper'

RSpec.describe "Potepan::Products", type: :request do
  let(:taxonomy) { create(:taxonomy) }
  let(:taxon) { create(:taxon, parent_id: taxonomy.root.id, taxonomy: taxonomy) }
  let!(:other_taxon) { create(:taxon, parent_id: taxonomy.root.id, taxonomy: taxonomy) }
  let!(:product) { create(:product, name: 'product', taxons: [taxon]) }
  let!(:related_product) { create(:product, name: 'related_product', taxons: [taxon]) }
  let!(:other_product) { create(:product, name: 'product_not_rerated', taxons: [other_taxon]) }

  before do
    get potepan_product_path(product.id)
  end

  describe '詳細ページテスト' do
    it "商品詳細ページから正常にレスポンスを返す" do
      expect(response).to have_http_status(200)
    end

    it '商品名が表示される' do
      expect(response.body).to include(product.name)
    end

    it '値段が表示される' do
      expect(response.body).to include(product.display_price.to_s)
    end

    it '説明が表示される' do
      expect(response.body).to include(product.description)
    end

    it '関連商品が表示される' do
      expect(response.body).to include(related_product.name)
      expect(response.body).to include(related_product.display_price.to_s)
      expect(response.body).not_to include(other_product.name)
    end
  end
end
