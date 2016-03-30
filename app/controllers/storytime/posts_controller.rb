require_dependency "storytime/application_controller"

module Storytime
  class PostsController < ApplicationController
    def show
      params[:id] = params[:id].split("/").last

      @post = if params[:preview]
        Post.find_preview(params[:id])
      else
        Post.published.friendly.find(params[:id])
      end

      authorize @post
      
      content_for :title, "#{@current_storytime_site.title} | #{@post.title}"

      @comments = @post.comments.order("created_at DESC")
      #allow overriding in the host app
      if params[:preview].nil? && !view_context.current_page?(storytime.post_path(@post))
        redirect_to storytime.post_path(@post), :status => :moved_permanently
      elsif lookup_context.template_exists?("storytime/#{@current_storytime_site.custom_view_path}/#{@post.type_name.pluralize}/#{@post.slug}")
        render "storytime/#{@current_storytime_site.custom_view_path}/#{@post.type_name.pluralize}/#{@post.slug}"
      elsif !lookup_show_template_override.nil?
        render lookup_show_template_override
      end
    end

  private 

    def lookup_show_template_override
      @lookup_show_template_override ||= begin
        @post.post_ancestor_klasses.each do |klass|
          template_path = "storytime/#{@current_storytime_site.custom_view_path}/#{klass.type_name.pluralize}/show"
          if lookup_context.template_exists?(template_path)
            @lookup_show_template_override = template_path
            return template_path
          end
        end

        nil
      end
    end

  end
end
