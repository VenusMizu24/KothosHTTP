require "net/http"
require "uri"
require "win32ole"
require 'fileutils'
require 'json'
require 'pp'

ENV['HTTP_PROXY'] = 'http://hostname:port88' # setting up proxy
  
$json = File.read('C:\Users\Nephtiry\Desktop\KothosHTTP.json') #Parsing JSON file
$obj = JSON.parse($json)
$string = $obj["FunctionString"] # Assigning variables to JSON strings/arrays
$timeform = $obj["Time"]

class Info

def createDir(dir) #Creating new directory
  begin
    network=WIN32OLE.new($string[0])
    username=network.username
    $dirName="C:"+$string[1]+Time.now.strftime($timeform[0])
      FileUtils.mkdir_p($dirName)
    return true
  rescue
  puts $string[6]
    return false
  end
  end
def createLog(logType) #Creating log
   begin
     $logName = ($dirName+$string[4]+Time.now.strftime($timeform[0])+$string[5])
     File.open($logName,"a") do |log|
     end
     return true
   rescue
     puts $string[7]
     return false
   end
 end
 def reporting(logText,ex) #Putting information in log
   begin
     File.open($logName,"a") do|logit|
       logit.puts Time.now.strftime($timeform[2])+"-#{logText}"
       puts Time.now.strftime($timeform[2])+"-#{logText}"
     end
   return true
   rescue
   puts $string[8]
   return false
   end
 end
end
  
  uri = URI.parse("http://www.thecityofkothos.com/") #Fetches the website
  http = Net::HTTP.new(uri.host, uri.port)
  
  request = Net::HTTP::Get.new("http://www.thecityofkothos.com")
  $response = http.request(request) #Sends request
  
class KothosHTTP < Info
  def gather
    begin
      $bin=Info.new
      $bin.createDir(false)
      $bin.createLog(false)
      $response.each_header do |header_name, header_value| #Sorts response headers
      $bin.reporting("#{header_name}, #{header_value}",false) #Puts resulting headers into file
      end
      $bin.reporting($string[9],false)
      add = [$response.body.count(".jpg"),$response.body.count(".gif"),$response.body.count(".png")] #Array to find image formats
      total = add.inject(:+) #adding results
      $bin.reporting("There are #{add[0]} JPGs, #{add[1]} GIFs, and #{add[2]} PNGs",false)
      $bin.reporting("***********There are #{total} total images on this page*************",false) #Counts images, puts result into log      
      $bin.reporting($string[10],false)
    end
  end
end

request2 = Net::HTTP::Get.new("http://www.thcityofkothos.com/")
$response1 = http.request(request2)

class Kothos2 < KothosHTTP #Same as above, just designed to fail
   def fail
    begin
      $response1.each_header do |header_name, header_value|
        $bin.reporting("#{header_name} : #{header_value}",false)
      end   
      $bin.reporting($string[11],false)
    end
end
end

#Instanciating classes
Report=KothosHTTP.new
Report.gather
Report2=Kothos2.new
Report2.fail