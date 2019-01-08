platform :ios, '10.0'
use_frameworks!

target 'EventFinder' do
  pod 'PromiseKit', '~> 6.0' 
end

target 'SeatGeekService' do
  pod 'PromiseKit', '~> 6.0'
  pod 'PromiseKit/Alamofire', '~> 6.0'
  pod 'SQLite.swift', '~> 0.11.5'
  #pod 'Alamofire', '~> 5.0.0.beta.1'

  target "SeatGeekServiceTests" do
    inherit! :search_paths
  end
end


