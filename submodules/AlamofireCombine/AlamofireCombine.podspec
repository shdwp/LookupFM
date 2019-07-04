Pod::Spec.new do |spec|
  spec.name         = 'AlamofireCombine'
  spec.version      = '0.0.1'
  spec.summary      = 'AlamofireCombine'
  spec.description  = <<-DESC
  AlamofireCombine
                   DESC

  spec.homepage     = 'https://github.com/shdwp/LookupFM'
  spec.author             = { 'Vasyl Horbachenko' => 'vasyl.horbachenko@globallogic.com' }
  spec.source       = { :git => "https://github.com/shdwp/AlamofireCombine", :tag => "#{spec.version}" }
  spec.source_files  = 'AlamofireCombine/**/*.{h,m,swift}'
  spec.platform = :ios, '13.0'

  spec.dependency 'Alamofire'
  spec.dependency 'AlamofireObjectMapper'
end
