class TweetsController < ApplicationController
    before_action :authenticate_user! 
    def index
      if params[:search] == nil
        @tweets= Tweet.all
      elsif params[:search] == " "
        @tweets= Tweet.all
      else
        #部分検索
        @tweets = Tweet.where("color LIKE ? ",'%' + params[:search] + '%')
      end
      
      if params[:tag_ids]
        @tweets = []
        params[:tag_ids].each do |key, value|
          if value == "1"
            tag_tweets = Tag.find_by(name: key).tweets
            @tweets = @tweets.empty? ? tag_tweets : @tweets & tag_tweets
          end
        end
      end
      
      if params[:tag]
        Tag.create(name: params[:tag])
      end

    end
  
  # 追加場所ここから
    def new
        @tweet = Tweet.new
    end
    
    def create
        tweet = Tweet.new(tweet_params)

        tweet.user_id = current_user.id 

        if tweet.save
          redirect_to :action => "index"
        else
          redirect_to :action => "new"
        end
    end
    
    def show
        @tweet = Tweet.find(params[:id])
        @comments = @tweet.comments
        @comment = Comment.new
    end
    
    def edit
        @tweet = Tweet.find(params[:id])
    end
    
    def update
        tweet = Tweet.find(params[:id])
        if tweet.update(tweet_params)
          redirect_to :action => "show", :id => tweet.id
        else
          redirect_to :action => "new"
        end
    end

    def destroy
        tweet = Tweet.find(params[:id])
        tweet.destroy
        redirect_to action: :index
    end

    private
    def tweet_params
        params.require(:tweet).permit(:color, :image, tag_ids: [])
    end
  
  
end