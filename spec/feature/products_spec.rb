require 'rails_helper'

RSpec.feature "Potepan::Products", type: :feature do
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
  let!(:product_with_taxon) do
    create(:product, name: 'product_with_taxon',
                     taxons: [taxon_a, taxon_b])
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
    let(:taxon_not_related) do
      create(:taxon, name: 'taxon_not_related', parent_id: taxonomy_b.root.id,
                     taxonomy: taxonomy_b)
    end
    let!(:product_id1_related_a) do
      create(:product, id: 1, name: 'product_id1_related_a',
                       taxons: [taxon_a])
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

    context '商品が関連商品を持つ場合' do
      before do
        visit potepan_product_path(product_with_taxon.id)
      end

      it '関連商品が順番通りに表示される' do
        within('.productsContent') do
          expect(page).to have_selector '.relation-0', text: product_id3_related_a_b.name
          expect(page).to have_selector '.relation-0', text: product_id3_related_a_b.
            display_price.to_s
          expect(page).to have_selector '.relation-1', text: product_id1_related_a.name
          expect(page).to have_selector '.relation-1', text: product_id1_related_a.
            display_price.to_s
          expect(page).to have_selector '.relation-2', text: product_id2_related_b.name
          expect(page).to have_selector '.relation-2', text: product_id2_related_b.
            display_price.to_s
          expect(page).not_to have_selector '.relation-3'
        end
      end

      it '関連商品の商品詳細にアクセスできる' do
        within('.productsContent') do
          find('.relation-0').click
          expect(current_path).to eq potepan_product_path(product_id3_related_a_b.id)
        end
      end

      it '関連しない商品は表示されない' do
        within('.productsContent') do
          expect(page).not_to have_content product_not_related.name
        end
      end

      it '詳細表示中の商品は表示されない' do
        within('.productsContent') do
          expect(page).not_to have_content product_with_taxon.name
        end
      end
    end

    context '商品が関連商品を持たない場合' do
      before do
        visit potepan_product_path(product_without_taxon.id)
      end

      it '関連商品は表示されない' do
        expect(page).not_to have_selector '.relation-0'
      end
    end
  end
end
