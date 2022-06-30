require 'rails_helper'

RSpec.describe "Potepan::Categories", type: :request do
  let(:taxonomy) { create(:taxonomy) }
  let(:taxon) { create(:taxon, parent_id: taxonomy.root.id, taxonomy: taxonomy) }
  let!(:product) { create(:product, name: 'product', taxons: [taxon]) }
  let!(:other_product) { create(:product, name: 'other_product') }

  before do
    get potepan_category_path(taxon.id)
  end

  describe 'カテゴリーページテスト' do
    it "カテゴリーページから正常にレスポンスを返す" do
      expect(response).to have_http_status(200)
    end

    it 'カテゴリーが表示される' do
      expect(response.body).to include(taxon.name)
    end

    it '関連商品のみ情報が表示される' do
      expect(response.body).to include(product.name)
      expect(response.body).to include(product.display_price.to_s)
      expect(response.body).not_to include(other_product.name)
    end

    it 'カテゴリー（最上位）が表示される' do
      within('.side-nav') do
        expect(page).to include(taxonomy.name)
      end
    end
  end
end
