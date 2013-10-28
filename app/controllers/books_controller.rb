class BooksController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: :destroy
  def index
  	@books =  Book.paginate_by_sql ["select a.id, a.user_id, a.name,a.created_at,
     a.content from books a, users b where a.user_id = b.id and (b.status='f' or b.id = ?)",current_user.id], :page => params[:page], :per_page => 3
  end

  def create
  	@book = current_user.books.build(book_params)
    if @book.save
      flash[:success] = "Book created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  def show
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def destroy
    @book.destroy
    redirect_to root_url
  end
  def edit
        @book = Book.find(params[:id])
  end
  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:success] = "Book updated"
      redirect_to @book
    else
      render 'edit'
    end
  end
  private

    def book_params
      params.require(:book).permit(:content,:name)
    end
     def correct_user
      @book = current_user.books.find_by(id: params[:id])
      redirect_to root_url if @book.nil?
    end
end