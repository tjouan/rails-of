class TrainingsController < ApplicationController
  TRAINING_ARTICLE_ZONE = 'training'.freeze

  def index
    @article = Article.find_by_zone(TRAINING_ARTICLE_ZONE)
  end
end
