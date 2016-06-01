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

  get "/numbers/evens" do
    if DB.empty?
      status 200
      json []
    else
      status 200
      json DB["evens"]
    end
  end

  get "/numbers/odds" do
    if DB.empty?
      status 200
      json []
    else
      status 200
      json DB["odds"]
    end
  end

  post "/numbers/evens" do

    if is_valid? params["number"]
      if DB["evens"]
        DB["evens"].push t_string
      else
        DB["evens"] = [t_string]
      end
      status 200
      json "success"

    else

      status 422
      json "status": "error", "error": "Invalid number: #{params["number"]}"
    end

  end

  post "/numbers/odds" do
    if is_valid? params["number"]
      if DB["odds"]
        DB["odds"].push t_string
      else
        DB["odds"] = [t_string]
      end
      status 200
      json "success"

    else

      status 422
      json "status": "error", "error": "Invalid number: #{params["number"]}"

    end
  end

  post "/numbers/primes" do
    if is_valid? params["number"]
      if DB["primes"]
        DB["primes"].push t_string
      else
        DB["primes"] = [t_string]
      end
      status 200
      json "success"

    else

      status 422
      json "status": "error", "error": "Invalid number: #{params["number"]}"

    end
  end


  delete "/numbers/odds" do
    status 200
    binding.pry
    DB["odds"].delete(t_string)

    json "success"

  end

  get "/numbers/primes/sum" do
    status 200
    json("status": "ok", "sum": DB["primes"].reduce(:+))
  end

  # post "/numbers/mine" do
    #   status 200
    #   json DB["primes"].reduce :+
    # end

    # if is_valid? params["number"]
    #   if DB["primes"]
    #     DB["primes"].push t_string
    #   else
    #     DB["primes"] = [t_string]
    #   end
    #   status 200
    #   json "success"

    # else

    #   status 422
    #   json "status": "error", "error": "Invalid number: #{params["number"]}"

    # end



end

Coloson.run! if $PROGRAM_NAME == __FILE__
