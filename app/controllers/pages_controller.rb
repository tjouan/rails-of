class PagesController < ApplicationController
  skip_before_filter :authenticate!, only: :terms

  def terms

  end
end
