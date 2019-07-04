Pod::Spec.new do |spec|
  spec.name         = 'LastFmSwift'
  spec.version      = '0.0.1'
  spec.summary      = 'LastFmSwift'
  spec.description  = <<-DESC
  LastFmSwift
                   DESC

  spec.homepage     = 'https://github.com/shdwp/LookupFM'
  spec.author             = { 'Vasyl Horbachenko' => 'vasyl.horbachenko@globallogic.com' }
  spec.source       = { :git => "https://github.com/shdwp/LastFmSwift", :tag => "#{spec.version}" }
  spec.source_files  = 'LastFmSwift/**/*.{h,m,swift}'
  spec.platform = :ios, '13.0'

  spec.dependency 'Alamofire'
  spec.dependency 'AlamofireObjectMapper'
end
