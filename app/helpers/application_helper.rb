module ApplicationHelper
  ACTIONS_ICONS = {
    account:    :user,
    check:      :check,
    contact:    :envelope,
    data:       :file_dup,
    delete:     :x,
    dashboard:  :home,
    download:   :download,
    edit:       :pencil,
    preview:    :lens,
    report:     :report,
    results:    :report,
    signin:     :enter,
    signout:    :exit,
    tools:      :gears,
    trainings:  :book,
    upload:     :upload
  }.freeze


  def embed_svg_sprite(filename)
    path = Rails.root.join('app', 'assets', 'images', filename)
    File.read(path).html_safe
  end

  def action_link(action, href, append_text: false, custom_text: nil)
    action_text = t(action.to_s)
    content_tag :li, class: action do
      options = action == :delete ?
        { method: :delete, data: { confirm: t('delete_confirm') } } :
        {}
      link_to href, options do
        out = svg_icon action, action_text
        out = [out, action_text].join(' ').html_safe if append_text
        out = [out, custom_text].join(' ').html_safe if custom_text
        out
      end
    end
  end

  def svg_icon(action, text)
    content_tag :svg, class: 'icon', alt: text, title: text do
      tag :use, 'xlink:href' => "#icon-#{ACTIONS_ICONS[action]}"
    end
  end

  def javascript_include_tag_prod(filepath)
    if Rails.configuration.host == Rails.configuration.host_prod
      javascript_include_tag filepath
    end
  end

  def markdown_format(str)
    str and markdown_parser.render(str).html_safe or nil
  end


  private

  def markdown_parser
    @_markdown_parser ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(
        filter_html:      true,
        no_styles:        true,
        safe_links_only:  true
      ),
      no_intra_emphasis:    true,
      fenced_code_blocks:   true,
      lax_spacing:          true,
      space_after_headers:  true,
      highlight:            true
    )
  end
end
