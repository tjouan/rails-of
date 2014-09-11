class Admin::DocsController < Admin::BaseController
  def markdown
    @article = Article.find_by_zone('doc')
  end
end
