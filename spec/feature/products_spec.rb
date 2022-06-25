require 'rails_helper'

RSpec.feature "Potepan::Products", type: :feature do
  let(:taxonomy_a) { create(:taxonomy) }
  let(:taxonomy_b) { create(:taxonomy) }
  let(:taxon_a) do
    create(:taxon, name: 'taxon_a', parent_id: taxonomy_a.root.id, taxonomy: taxonomy_a)
  end
  let(:taxon_b) do
    create(:taxon, name: 'taxon_b', parent_id: taxonomy_b.root.id, taxonomy: taxonomy_b)
  end
  let!(:product_with_taxon) do
    create(:product, name: 'product_with_taxon', taxons: [taxon_a, taxon_b])
  end
  let(:product_without_taxon) { create(:product, name: 'product_without_taxon') }

  describe '商品詳細ページから「一覧ページに戻る」機能' do
    context 'カテゴリーページから商品詳細ページにアクセスした場合' do
      before do
        visit potepan_category_path(taxon_b.id)
        click_on product_with_taxon.name
      end

      it 'taxonのカテゴリーページに戻る' do
        click_on '一覧ページに戻る'
        expect(current_path).to eq potepan_category_path(taxon_b.id)
      end
    end

    context 'カテゴリーページ以外から商品詳細ページにアクセスした場合' do
      context '商品がtaxonを持っている場合' do
        it 'taxonのカテゴリーページを表示する' do
          visit potepan_product_path(product_with_taxon.id)
          click_on '一覧ページに戻る'
          expect(current_path).to eq potepan_category_path(taxon_a.id)
        end
      end

      context '商品がtaxonを持っていない場合' do
        it 'ホームページに戻る' do
          visit potepan_product_path(product_without_taxon.id)
          click_on '一覧ページに戻る'
          expect(current_path).to eq potepan_path
        end
      end
    end
  end

  describe '関連商品を表示する機能' do
    let!(:product_related) do
      create(:product, name: 'product_related', taxons: [taxon_a])
    end

    before do
      visit potepan_product_path(product_with_taxon.id)
    end

    it '関連商品の情報が表示される' do
      within('.productsContent') do
        expect(page).to have_selector '.relation-0', text: product_related.name
        expect(page).to have_selector '.relation-0', text: product_related.display_price.to_s
      end
    end

    it '関連商品の商品詳細にアクセスできる' do
      within('.productsContent') do
        find('.relation-0').click
        expect(current_path).to eq potepan_product_path(product_related.id)
      end
    end
  end
end
