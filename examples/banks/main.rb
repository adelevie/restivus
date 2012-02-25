require 'restivus'

class Bank < Restivus
  pk "Bank_Name"     # defaults to "id"
  csv "banklist.csv" # from http://www.fdic.gov/bank/individual/failed/banklist.csv
end

Bank.run!