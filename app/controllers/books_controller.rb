class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all.with_associations(:author, :categories)
    @recommendations = Book.recommendations
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    bp = book_params
    categories = Category.where(:id => book_params[:category_ids]).pluck(:name)
    p "---------------- category list -----------------"
    categories.each do |cat|
      p cat
    end
    if categories.include?("New Category")
      new_category = Category.new(name: book_params[:other_cat])
      if new_category.save
        flash[:message] = "New Category Added."
        p "-------------------- adding category ----------------"
        p "new cat id: #{new_category.id}"
        p "old cat id: #{Category.find_by(name: "New Category").id}"
        bp[:category_ids].delete("#{Category.find_by(name: "New Category").id}")
        bp[:category_ids] << "#{new_category.id}"
        p "bp: #{bp[:category_ids]}"
      end
    end
    respond_to do |format|
      if @book.update(bp)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:isbn, :title, :year_published, :author, :other_cat, :category_ids => [])
    end
end
