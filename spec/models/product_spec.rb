require 'rails_helper'

RSpec.describe "Potepan::Product", type: :model do
  let(:taxonomy_a) { create(:taxonomy, position: 1) }
  let(:taxonomy_b) { create(:taxonomy, position: 2) }
  let(:taxon_a) { create(:taxon, parent_id: taxonomy_a.root.id, taxonomy: taxonomy_a) }
  let(:taxon_b) { create(:taxon, parent_id: taxonomy_b.root.id, taxonomy: taxonomy_b) }
  let(:taxon_c) { create(:taxon, parent_id: taxonomy_b.root.id, taxonomy: taxonomy_b) }
  let(:product) { create(:product, taxons: taxons) }
  let!(:product_id1_related_a) { create(:product, id: 1, taxons: [taxon_a]) }
  let!(:product_id2_related_b) { create(:product, id: 2, taxons: [taxon_b]) }
  let!(:product_id3_related_a_b) { create(:product, id: 3, taxons: [taxon_a, taxon_b]) }
  let!(:product_id4_related_c) { create(:product, id: 4, taxons: [taxon_c]) }

  describe '#list_up_relations' do
    subject { product.list_up_relations }

    context '商品が関連商品を持つ場合' do
      let(:taxons) { [taxon_a, taxon_b] }

      it '関連商品のみを順番通りに取得する' do
        is_expected.to eq [product_id3_related_a_b, product_id1_related_a, product_id2_related_b]
      end
    end

    context '商品がtaxonを持たない場合' do
      let(:taxons) { [] }

      it '商品情報は取得されない' do
        is_expected.to eq []
      end
    end
  end
end
