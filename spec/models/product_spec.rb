require 'rails_helper'

RSpec.describe "Potepan::Product", type: :model do
  let(:primary_taxonomy) { create(:taxonomy, position: 1) }
  let(:secondary_taxonomy) { create(:taxonomy, position: 2) }
  let(:primary_taxon) do
    create(:taxon, parent_id: primary_taxonomy.root.id, taxonomy: primary_taxonomy)
  end
  let(:secondary_taxon) do
    create(:taxon, parent_id: secondary_taxonomy.root.id, taxonomy: secondary_taxonomy)
  end
  let(:other_taxon) do
    create(:taxon, parent_id: secondary_taxonomy.root.id, taxonomy: secondary_taxonomy)
  end
  let(:product) { create(:product, taxons: taxons) }
  let!(:secondary_related_product) { create(:product, taxons: [primary_taxon]) }
  let!(:tertiary_related_product) { create(:product, taxons: [secondary_taxon]) }
  let!(:primary_related_product) do
    create(:product, taxons: [primary_taxon, secondary_taxon])
  end
  let!(:other_product) { create(:product, taxons: [other_taxon]) }

  describe '#list_up_relations' do
    subject { product.list_up_relations }

    context '商品が関連商品を持つ場合' do
      let(:taxons) { [primary_taxon, secondary_taxon] }

      it '関連商品のみを順番通りに取得する' do
        is_expected.to eq [
          primary_related_product,
          secondary_related_product,
          tertiary_related_product,
        ]
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
