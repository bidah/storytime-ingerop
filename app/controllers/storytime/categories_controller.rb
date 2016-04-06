require_dependency "storytime/application_controller"

module Storytime
  class CategoriesController < ApplicationController
    layout 'layouts/application'
    def edificacion
      @posts = @current_storytime_site.homepage.posts

      @edificacion = @posts.select do |post|
        post.tags.any? do |tag|
          tag.name.include? "edificacion"
        end
      end
    end

    def energia
      @posts = @current_storytime_site.homepage.posts

      @energia = @posts.select do |post|
        post.tags.any? do |tag|
          tag.name.include? "energia"
        end
      end
    end

  end
end

