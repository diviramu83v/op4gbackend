# frozen_string_literal: true

# View helpers for campaign pages.
module CampaignHelper
  def campaign_menu_link(url, label)
    link_to campaign_link_content(label), url, class: menu_link_class(url)
  end

  def campaign_add_link(url, label, method = :get)
    link_to campaign_add_content(label), url, method: method, class: menu_link_class(url)
  end

  def campaign_link_content(label)
    content = []
    content << tag.i(nil, class: 'fa fa-caret-right ml-2 mr-2')
    content << tag.span(label)
    safe_join(content)
  end

  def campaign_add_content(label)
    content = []
    content << tag.i(nil, class: 'fa fa-plus-circle mr-2')
    content << tag.span(label)
    safe_join(content)
  end

  def menu_link_class(menu_link_url)
    page_url = request.original_url

    page_url == menu_link_url ? 'p-0 mb-2 nav-link active' : 'p-0 mb-2 nav-link'
  end
end
