# encoding: utf-8

def uuid?(value)
  (value =~ /^[0-9a-f]{8}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{12}$/) != nil
end

def demo_hash
  {"homer" => "Homer Simpson", "marge" => "Marge Simpson", "lisa" => "Lisa Simpson", "bart" => "Bart Simpson", "maggy" => "Maggy Simpson"}
end

def second_demo_hash
  {"homer" => "Simpson Homer", "marge" => "Simpson Marge", "lisa" => "Simpson Lisa", "bart" => "Simpson Bart", "maggy" => "Simpson Maggy"}
end