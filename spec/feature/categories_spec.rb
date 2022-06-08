require 'rails_helper'

RSpec.feature "Potepan::Categories", type: :feature do
  given(:taxonomy) { create(:taxonomy) }
  given(:taxon_a) { create(:taxon, name: 'taxon_a', parent_id: taxonomy.root.id, taxonomy: taxonomy) }
  given(:taxon_b) { create(:taxon, name: 'taxon_b', parent_id: taxonomy.root.id, taxonomy: taxonomy) }
  given!(:product_a) { create(:product, name: 'product_a', taxons: [taxon_a]) }
  given!(:product_b){ create(:product, name: 'product_b', taxons: [taxon_b]) }

  context 'taxon_aのカテゴリーページを表示した場合' do
    background do
      visit potepan_category_path(taxon_a.id)
    end

    scenario 'ページヘッダーにtaxon_aの名前が表示される' do
      expect(page).to have_selector '.page-title', text: taxon_a.name
      expect(page).to have_selector '.pull-right li', text: taxon_a.name
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
        expect(page).to have_content taxon_a.name
        expect(page).to have_content taxon_a.products.count
        expect(page).to have_content taxon_b.name
        expect(page).to have_content taxon_b.products.count
      end
    end

    scenario 'ツリーから他のtaxonのカテゴリーページにアクセスできる' do
      click_on taxonomy.name
      click_on taxon_b.name
      expect(current_path).to eq potepan_category_path(taxon_b.id)
    end

    scenario 'taxon_aの関連商品のみ表示される' do
      expect(page).to have_content product_a.name
      expect(page).to have_content product_a.display_price
      expect(page).not_to have_content product_b.name
    end

    scenario '関連商品の商品詳細ページにアクセスできる' do
      click_on product_a.name
      expect(current_path).to eq potepan_product_path(product_a.id)
    end
  end
end
