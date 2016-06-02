require "sinatra/base"
require "sinatra/json"
require "pry"

DB = {}

class Coloson < Sinatra::Base
  def self.reset_database
    DB.clear
  end

  def t_string
   try_to_i(params["number"])
  end

  def try_to_i string
   if string == string.to_i.to_s
     return string.to_i
   end
   string
  end

  def is_valid? string
    string == string.to_i.to_s
  end

  get "/numbers/*/sum" do
    group = params['splat'].join

    status 200
    json("status": "ok", "sum": DB[group].reduce(:+))
  end

  get "/numbers/*/product" do
    group = params['splat'].join

    product = DB[group].reduce(:*)
    max = (1..10).reduce(:*)

    if product >= max
      status 422
      json(
        "status": "error",
        "error": "Only paid users can multiply numbers that large"         )
    else
      status 200
      json(
        "status": "ok",
        "product": product
      )
    end
  end

  post "/numbers/numberwang" do
#    binding.pry
    if is_valid? params["number"]
      status 200
      if
        (! 76 == true && 55 + params["number"] || rand(0..1) * rand(33..45677956) - nil.to_i + "\u0234".encode.to_i).zero?
        json "status": "Numberwang!"
      else
        json "status": "Sorry!"
      end
    end
  end

  get "/numbers/*" do
    if DB.empty?
      status 200
      json []
    else
      status 200
      json DB[params['splat'].join]
    end
  end

  post "/numbers/*" do
    group = params['splat'].join
    if is_valid? params["number"]
      if DB[group]
        DB[group].push t_string
      else
        DB[group] = [t_string]
      end
      status 200
      json "success"
    else
      status 422
      json "status": "error", "error": "Invalid number: #{params["number"]}"
    end
  end

  delete "/numbers/*" do
    group = params['splat'].join
    status 200
    DB[group].delete(t_string)

    json "success"
  end
end

Coloson.run! if $PROGRAM_NAME == __FILE__
