Pod::Spec.new do |s|
  s.name         = "NSEnumeratorLinq"
  s.version      = "0.2.7"
  s.summary      = "NSEnumerator LINQ category."
  s.homepage     = "https://github.com/k06a/NSEnumeratorLinq"
  s.license      = 'MIT'
  s.author       = { "Anton Bukov" => "k06aaa@gmail.com" }
  s.source       = { :git => "https://github.com/k06a/NSEnumeratorLinq.git", :tag => ‘0.2.7’ }
  s.platform     = :ios, '1.0'
  s.source_files = 'NSEnumeratorLinq/**/*.{h,m}'
  s.requires_arc = true
end
