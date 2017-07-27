class BooksController < ApplicationController
  before_action :set_cache_control_headers
  def index
    @books = Book.all
    set_surrogate_key_header 'books', @books.map(&:record_key)
  end

  def create
    random_number = rand(10000)
    book = Book.new(title: "Book ##{random_number}", author: "Author ##{random_number}")
    if book.save
      book.purge_all
      redirect_to root_path, notice: "Book ##{random_number} created."
      puts ""
      puts flash.inspect
      puts ""
    end
  end

  def destroy
    book = Book.find(params[:id])
    title = book.title
    if book.destroy
      book.purge
      book.purge_all
      redirect_to root_path, notice: "#{title} deleted."
    end
  end
end
