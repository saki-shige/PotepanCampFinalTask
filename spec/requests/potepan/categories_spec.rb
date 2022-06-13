require 'rails_helper'

RSpec.describe "Potepan::Categories", type: :request do
  let(:taxonomy) { create(:taxonomy) }
  let(:taxon_a) do
    create(:taxon, name: 'taxon_a', parent_id: taxonomy.root.id,
                   taxonomy: taxonomy)
  end
  let!(:product_a) { create(:product, name: 'product_a', taxons: [taxon_a]) }
  let!(:product_b) { create(:product, name: 'product_b') }

  before do
    get potepan_category_path(taxon_a.id)
  end

  describe 'カテゴリーページテスト' do
    it "カテゴリーページから正常にレスポンスを返す" do
      expect(response).to have_http_status(200)
    end

    it 'カテゴリーが表示される' do
      expect(response.body).to include(taxon_a.name)
    end

    it '関連商品のみ情報が表示される' do
      expect(response.body).to include(product_a.name)
      expect(response.body).to include(product_a.display_price.to_s)
      expect(response.body).not_to include(product_b.name)
    end

    it 'カテゴリー（最上位）が表示される' do
      within('.side-nav') do
        expect(page).to include(taxonomy.name)
      end
    end
  end
end
