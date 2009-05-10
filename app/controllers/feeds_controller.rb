class FeedsController < ActionController::Base
  layout 'application'

  def index
    @feeds = Feed.find(:all, :include => :posts)
  end

  def show
    @feed = Feed.find(params[:id])
    render :partial => 'feed', :locals => { :feed => @feed }
  end

  def create
    feed = Feed.create! :url => params[:url]
    redirect_to :action => :index
  end

  def refresh
    Feed.find(params[:id]).fetch
    head :ok
  end

  def refresh_all
    Feed.fetch_all
    head :ok
  end
end
