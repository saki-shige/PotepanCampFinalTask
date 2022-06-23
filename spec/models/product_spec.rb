require 'rails_helper'

RSpec.describe "Potepan::Product", type: :model do
  let(:taxonomy_a) { create(:taxonomy, position: 1) }
  let(:taxonomy_b) { create(:taxonomy, position: 2) }
  let(:taxon_a) do
    create(:taxon, name: 'taxon_a', parent_id: taxonomy_a.root.id, taxonomy: taxonomy_a)
  end
  let(:taxon_b) do
    create(:taxon, name: 'taxon_b', parent_id: taxonomy_b.root.id, taxonomy: taxonomy_b)
  end
  let(:taxon_not_related) do
    create(:taxon, name: 'taxon_not_related', parent_id: taxonomy_b.root.id, taxonomy: taxonomy_b)
  end
  let(:product_with_taxon) do
    create(:product, name: 'product_with_taxon', taxons: [taxon_a, taxon_b])
  end
  let(:product_without_taxon) { create(:product, name: 'product_without_taxon') }
  let!(:product_id1_related_a) do
    create(:product, id: 1, name: 'product_id1_related_a', taxons: [taxon_a])
  end
  let!(:product_id2_related_b) do
    create(:product, id: 2, name: 'product_id2_related_b', taxons: [taxon_b])
  end
  let!(:product_id3_related_a_b) do
    create(:product, id: 3, name: 'product_id3_related_a_b', taxons: [taxon_a, taxon_b])
  end
  let!(:product_id4_related_b) do
    create(:product, id: 4, name: 'product_id4_related_b', taxons: [taxon_b])
  end
  let!(:product_not_related) do
    create(:product, name: 'product_not_rerated', taxons: [taxon_not_related])
  end

  describe '関連商品を抽出する機能' do
    context '商品が関連商品を指定数以上持つ場合' do
      it '関連商品のみを指定数順番通りに取得する' do
        expect(product_with_taxon.list_up_relations(limit: 3)).to eq [product_id3_related_a_b, product_id1_related_a, product_id4_related_b]
      end
    end

    context '商品が関連商品を持たない場合' do
      it '商品情報は取得されない' do
        expect(product_without_taxon.list_up_relations(limit: 3)).to eq []
      end
    end
  end
end
