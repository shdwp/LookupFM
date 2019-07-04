Pod::Spec.new do |spec|
  spec.name         = 'DiscogsSwift'
  spec.version      = '0.0.1'
  spec.summary      = 'DiscogsSwift'
  spec.description  = <<-DESC
  DiscogsSwift
                   DESC

  spec.homepage     = 'https://github.com/shdwp/LookupFM'
  spec.author             = { 'Vasyl Horbachenko' => 'vasyl.horbachenko@globallogic.com' }
  spec.source       = { :git => "https://github.com/shdwp/DiscogsSwift", :tag => "#{spec.version}" }
  spec.source_files  = 'DiscogsSwift/**/*.{h,m,swift}'
  spec.platform = :ios, '13.0'

  spec.dependency 'Alamofire'
  spec.dependency 'AlamofireObjectMapper'
end
