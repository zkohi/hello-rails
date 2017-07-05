require 'rails_helper'

RSpec.feature 'Blog管理', :type => :feature do
  scenario 'Blogの新規作成時にtitleを入力しなかった場合にエラーが表示されること' do
    visit new_blog_path

    fill_in 'Title', :with => ''

    expect {
      click_button 'Save'
    }.to change(Blog, :count).by(0)
    expect(page).to have_current_path(blogs_path)
    expect(page).to have_text('1 error prohibited this blog from being saved:')
  end

  scenario 'Blogの新規作成時にtitleを入力した場合はデータが保存され閲覧画面に遷移すること' do
    visit new_blog_path

    fill_in 'Title', :with => 'title'

    expect {
      click_button 'Save'
    }.to change(Blog, :count).by(1)
    expect(page).to have_current_path(blog_path(Blog.last))
    expect(page).to have_text('Blog was successfully created.')
  end
end
