require "features_helper"

RSpec.describe "list books" do
  it "displays each book on the page" do
    visit "/books"
    within "#books" do
      expect(page.has_css?('.book', count: 2)).to be_truthy
    end
  end
end
