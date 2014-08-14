module ApplicationHelper
  ACTIONS_ICONS = {
    preview:  :lens,
    download: :download,
    edit:     :pencil,
    delete:   :x,
    report:   :report
  }.freeze


  def embed_svg_sprite(filename)
    path = Rails.root.join('app', 'assets', 'images', filename)
    File.new(path).read.html_safe
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
end
