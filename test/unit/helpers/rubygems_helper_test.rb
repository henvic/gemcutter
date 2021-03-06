require File.expand_path("../../../test_helper", __FILE__)

class RubygemsHelperTest < ActionView::TestCase
  include Rails.application.routes.url_helpers

  should "create the directory" do
    directory = link_to_directory
    ("A".."Z").each do |letter|
      assert_match rubygems_path(:letter => letter), directory
    end
  end

  should "link to docs if no docs link is set" do
    version = Factory.build(:version)
    linkset = Factory.build(:linkset, :docs => nil)
    
    link = documentation_link(version, linkset)
    assert link.include?(documentation_path(version))
  end

  should "not link to docs if docs link is set" do
    version = Factory.build(:version)
    linkset = Factory.build(:linkset)
    
    link = documentation_link(version, linkset)
    assert link.blank?
  end

  context "creating linkset links" do
    setup do
      @linkset = Factory.build(:linkset)
      @linkset.wiki = nil
      @linkset.code = ""
    end

    should "create link for homepage" do
      assert_match @linkset.home, link_to_page("Homepage", @linkset.home)
    end

    should "be a nofollow link" do
      assert_match 'rel="nofollow"', link_to_page("Homepage", @linkset.home)
    end

    should "not create link for wiki" do
      assert_nil link_to_page("Wiki", @linkset.wiki)
    end

    should "not create link for code" do
      assert_nil link_to_page("Code", @linkset.code)
    end
  end

  should "create links to owners gem overviews" do
    users = Array.new(2) { Factory(:email_confirmed_user) }
    create_gem(*users)
    expected_links = users.map { |u| link_to u.handle, user_rubygems_path(u) }.join(", ")
    assert_equal expected_links, links_to_owners(@rubygem)
    assert links_to_owners(@rubygem).html_safe?
  end
end
