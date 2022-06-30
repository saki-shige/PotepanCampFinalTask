require 'rails_helper'

RSpec.feature "Potepan::Products", type: :feature do
  let(:taxonomy) { create(:taxonomy) }
  let(:primary_taxon) do
    create(:taxon, parent_id: taxonomy.root.id, taxonomy: taxonomy)
  end
  let(:secondary_taxon) do
    create(:taxon, parent_id: taxonomy.root.id, taxonomy: taxonomy)
  end
  let!(:product) do
    create(:product, taxons: [primary_taxon, secondary_taxon])
  end
  let(:product_without_taxon) { create(:product) }

  describe '商品詳細ページから「一覧ページに戻る」機能' do
    context 'カテゴリーページから商品詳細ページにアクセスした場合' do
      before do
        visit potepan_category_path(secondary_taxon.id)
        click_on product.name
      end

      it 'taxonのカテゴリーページに戻る' do
        click_on '一覧ページに戻る'
        expect(current_path).to eq potepan_category_path(secondary_taxon.id)
      end
    end

    context 'カテゴリーページ以外から商品詳細ページにアクセスした場合' do
      context '商品がtaxonを持っている場合' do
        it 'taxonのカテゴリーページを表示する' do
          visit potepan_product_path(product.id)
          click_on '一覧ページに戻る'
          expect(current_path).to eq potepan_category_path(primary_taxon.id)
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
    let!(:related_but_not_displayed_product) do
      create(:product, name: 'not_displayed', taxons: [primary_taxon])
    end
    let!(:related_products) { create_list(:product, 4, taxons: [primary_taxon]) }

    before do
      visit potepan_product_path(product.id)
    end

    it '関連商品の情報が表示される' do
      within('.productsContent') do
        related_products.each_with_index do |related_product, i|
          expect(page).to have_selector ".relation-#{3 - i}", text: related_product.name
          expect(page).to have_selector ".relation-#{3 - i}",
                                        text: related_product.display_price.to_s
        end
      end
    end

    it '５つ目の関連商品は表示されない' do
      within('.productsContent') do
        expect(page).not_to have_content related_but_not_displayed_product.name
      end
    end

    it '関連商品の商品詳細にアクセスできる' do
      within('.productsContent') do
        find('.relation-0').click
        expect(current_path).to eq potepan_product_path(related_products[3].id)
      end
    end
  end
end
