require 'sinatra'
require 'sinatra/base'
require 'sinatra/param'

helpers Sinatra::Param

get '/' do
  erb :index, :locals => {:name => params[:name]}
end

post '/result' do
  MAX_CREDIT = 999999999999999
  MAX_PERCENT = 99999999999999
  param :percent, Float, min: 0, max: MAX_PERCENT, blank: false
  param :credit_sum, Float, min: 0, max: MAX_CREDIT, blank: false
  param :term, Integer, min: 1, max: 1200, blank: false
  erb :result, :locals => {:params => request.POST}
end
