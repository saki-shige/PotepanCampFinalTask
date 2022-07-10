require 'rails_helper'

RSpec.feature "Potepan::Categories", type: :feature do
  given(:taxonomy) { create(:taxonomy) }
  given(:taxon) do
    create(:taxon, name: 'taxon', parent_id: taxonomy.root.id,
                   taxonomy: taxonomy)
  end
  given(:other_taxon) do
    create(:taxon, name: 'other_taxon', parent_id: taxonomy.root.id,
                   taxonomy: taxonomy)
  end
  given!(:product) { create(:product, name: 'product', taxons: [taxon]) }
  given!(:other_product) { create(:product, name: 'other_product', taxons: [other_taxon]) }

  describe 'カテゴリー一覧画面' do
    context 'taxonのカテゴリーページを表示した場合' do
      background do
        visit potepan_category_path(taxon.id)
      end

      scenario 'ページヘッダーにtaxonの名前が表示される' do
        expect(page).to have_selector '.page-title', text: taxon.name
        expect(page).to have_selector '.pull-right li', text: taxon.name
      end

      scenario 'ページヘッダーからホームページにアクセスできる' do
        within('.pageHeader') do
          click_on 'Home'
          expect(current_path).to eq potepan_path
        end
      end

      scenario 'taxonomyのツリーが正常に表示される' do
        within('.side-nav') do
          expect(page).to have_content taxonomy.name
          click_on taxonomy.name
          expect(page).to have_content taxon.name
          expect(page).to have_content taxon.products.count
          expect(page).to have_content other_taxon.name
          expect(page).to have_content other_taxon.products.count
        end
      end

      scenario 'ツリーから他のtaxonのカテゴリーページにアクセスできる' do
        click_on taxonomy.name
        click_on other_taxon.name
        expect(current_path).to eq potepan_category_path(other_taxon.id)
      end

      scenario 'taxonの関連商品のみ表示される' do
        expect(page).to have_content product.name
        expect(page).to have_content product.display_price
        expect(page).not_to have_content other_product.name
      end

      scenario '関連商品の商品詳細ページにアクセスできる' do
        target_class = ".category-#{product.id}-display"
        find(target_class).click
        expect(current_path).to eq potepan_product_path(product.id)
      end
    end
  end
end
