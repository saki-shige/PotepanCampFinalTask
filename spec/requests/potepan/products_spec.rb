require 'rails_helper'

RSpec.describe "Potepan::Products", type: :request do
  let(:taxonomy_a) { create(:taxonomy, position: 1) }
  let(:taxonomy_b) { create(:taxonomy, position: 2) }
  let(:taxon_a) do
    create(:taxon, name: 'taxon_a', parent_id: taxonomy_a.root.id,
                   taxonomy: taxonomy_a)
  end
  let(:taxon_b) do
    create(:taxon, name: 'taxon_b', parent_id: taxonomy_b.root.id,
                   taxonomy: taxonomy_b)
  end
  let!(:taxon_not_related) do
    create(:taxon, name: 'taxon_not_related', parent_id: taxonomy_b.root.id,
                   taxonomy: taxonomy_b)
  end
  let!(:product_with_taxon) do
    create(:product, name: 'product_with_taxon', taxons: [taxon_a, taxon_b])
  end
  let!(:product_id1_related_a) do
    create(:product, id: 1, name: 'product_id1_related_a', taxons: [taxon_a])
  end
  let!(:product_id2_related_b) do
    create(:product, id: 2, name: 'product_id2_related_b', taxons: [taxon_b])
  end
  let!(:product_id3_related_a_b) do
    create(:product, id: 3, name: 'product_id3_related_a_b', taxons: [taxon_a, taxon_b])
  end
  let!(:product_not_related) do
    create(:product, name: 'product_not_rerated', taxons: [taxon_not_related])
  end

  before do
    get potepan_product_path(product_with_taxon.id)
  end

  describe '詳細ページテスト' do
    it "商品詳細ページから正常にレスポンスを返す" do
      expect(response).to have_http_status(200)
    end

    it '商品名が表示される' do
      expect(response.body).to include(product_with_taxon.name)
    end

    it '値段が表示される' do
      expect(response.body).to include(product_with_taxon.display_price.to_s)
    end

    it '説明が表示される' do
      expect(response.body).to include(product_with_taxon.description)
    end

    it '関連商品が表示される' do
      expect(response.body).to include(product_id1_related_a.name)
      expect(response.body).to include(product_id1_related_a.display_price.to_s)
      expect(response.body).to include(product_id2_related_b.name)
      expect(response.body).to include(product_id2_related_b.display_price.to_s)
      expect(response.body).to include(product_id3_related_a_b.name)
      expect(response.body).to include(product_id3_related_a_b.display_price.to_s)
      expect(response.body).not_to include(product_not_related.name)
    end
  end
end
