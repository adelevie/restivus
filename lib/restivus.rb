require 'json'
require 'csv'
require 'uri'
require 'sinatra'

class Restivus < Sinatra::Base
  
  # Doc helpers
  # these methods generate text for the docs pages
  # ------------
  
  def curl_req(url)
    `curl #{url}`
  end
  
  def truncated_response(url)
    json = curl_req(url)
    h = JSON.parse(json)
    
    if h["results"]
      h["results"] = h["results"].first(3)
      return JSON.pretty_generate(h)
    else
      return JSON.pretty_generate(h)
    end
  end
  
  def format_curl_req(url, description="TODO", http="TODO", url_schema="TODO", div="TODO")
    result = {
      :cmd => "$ curl #{url}",
      :raw_response => curl_req(url),
      :pretty_response => truncated_response(url),#JSON.pretty_generate(JSON.parse(curl_req(url))),
      :description => description,
      :http_verb => http,
      :url_schema => url_schema,
      :div_id => div
    }
      
    result
  end
  
  def resource_name
    self.class.name
  end
  
  def self.fields
    @@fields
  end
  
  # ----------
  
  def self.csv(filename)
    csv_data = CSV.read filename
    headers = csv_data.shift.map {|i| i.to_s }
    headers.map! {|h| h.gsub(" ", "_")}
    @@fields = headers
    string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
    array_of_hashes = string_data.map {|row| Hash[*headers.zip(row).flatten] }
    @@results = array_of_hashes
  end
  
  def self.pk(key="id")
    @@pk = key
  end
  
  def self.find(id)
    where(@@pk => id.to_s).first
  end

  def self.where(conditions={})    
    results = @@results.select do |result|
      conditions.all? { |k,v| result[k] == v }
    end
  end
  
  def self.all
    @@results
  end
  
  def delete_splat(params)
    %w[splat captures resource].each {|w| params.delete(w)}
    params
  end
  
  def base_uri
    uri = "http://#{request.host}"
    
    if request.port
      uri << ":#{request.port}"
    end
    
    uri
  end
  
  get "/docs" do
    @fields = self.class.fields
    @base_uri = base_uri
    @resource_name = resource_name
    
    @sample_calls = []
    #description="TODO", http="TODO", url_schema="TODO"
    @sample_calls << get_index = format_curl_req("#{@base_uri}/#{@resource_name.downcase}", "Show all #{@resource_name} objects", "GET", "#{@base_uri}/#{@resource_name.downcase}", "index")    
    
    obj = self.class.all.first
    pk_val = URI.encode(obj[@@pk])
    
    @sample_calls << get_show = format_curl_req("#{@base_uri}/#{@resource_name.downcase}/#{pk_val}", "Show individual #{@resource_name} objects by #{@@pk}", "GET", "#{@base_uri}/#{@resource_name.downcase}/&lt;#{@@pk}&gt;", "show")
    
    key = obj.keys.last
    val = obj[key]    
    
    @sample_calls << get_find = format_curl_req("#{@base_uri}/#{@resource_name.downcase}?#{key}=#{val}", "Query #{@resource_name} objects based on parameters", "GET", "#{@base_uri}/#{@resource_name.downcase}?&lt;param&gt;=&lt;value&gt;", "find")
    erb :docs
  end
  
  get "/:resource" do
    content_type :json
    case params.keys.length
    when 0 # /:resource
      {"results" => self.class.all}.to_json
    else # /:resource?key=value&...
      constraints = delete_splat(params)
      {"results" => self.class.where(constraints)}.to_json
    end
  end
  
  get "/:resource/:id" do
    content_type :json
    self.class.find(params[:id].to_s).to_json
  end

end

# Usage:

#class Person < Restivus
#  csv "example.csv"
#end

#class Bank < Restivus
#  csv "banks.csv"
#  pk "Bank_Name"
#end