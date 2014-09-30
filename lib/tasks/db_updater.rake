require 'rubygems'
require 'json'
require "open-uri"

namespace :db_updater do
  desc "Populate db first time using google apis"
  task :populate_db => :environment do
    # http = Curl.get("https://www.googleapis.com/books/v1/volumes?q=fairy%20tales&start_index=800&maxResults=40")
    # BooksController.populateDB(http.body_str)
    ["romance","suspense","biography","fantasy"].each do |genre|
      http_url = "https://www.googleapis.com/books/v1/volumes?q="+genre+"&start_index=800&maxResults=40"
      puts http_url
      http_content = Curl.get(http_url)
      booksData = JSON.parse(http_content.body_str)
      booksList = booksData["items"]
      booksList.each do |bookData|
        book = Book.new;
        bookInfo = bookData["volumeInfo"]
        book[:title] = bookInfo["title"]
        puts bookInfo["title"]
        book[:genre] = genre
        if(bookInfo["authors"] != nil) then 
          author = Author.new
          author[:title] = bookInfo["authors"][0]
          book_author = author.save
          book[:author_id] = author.id
        end
        book[:publisher] = bookInfo["publisher"]
        book[:published_year] = bookInfo["publishedDate"]
        book[:language] = bookInfo["language"]
        book[:rating] = bookInfo["averageRating"]
        saleInfo = bookData["saleInfo"]
        if saleInfo["saleability"] == "NOT_FOR_SALE"
          book[:price] = 0
        else 
          if saleInfo["listPrice"] != nil
            book[:price] = saleInfo["listPrice"]["amount"]
          end
        end
        #image
        bookImgUrl = bookInfo["imageLinks"]["thumbnail"]
        extname = File.extname(bookImgUrl)
        basename = File.basename(bookImgUrl, extname)
      
        file = Tempfile.new([basename, extname])
        file.binmode
      
        open(URI.parse(bookImgUrl)) do |data|  
          file.write data.read
        end

        file.rewind
      
        book.cover = file 
        book.save
      end
    end
  end
end