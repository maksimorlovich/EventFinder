platform :ios, '11.0'
use_frameworks!

target 'EventFinder' do
  pod 'PromiseKit', '~> 6.0' 
end

target 'SeatGeekService' do
  pod 'PromiseKit', '~> 6.0'
  pod 'PromiseKit/Alamofire', '~> 6.0'
  pod 'SQLite.swift', '~> 0.11.5'

  target "SeatGeekServiceTests" do
    inherit! :search_paths
  end
end


