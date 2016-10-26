module Diagnostics

  def diagnostics
    ["<pre>",
      "Verb: #{self.verb}",
      "Path: #{self.path}",
      "Protocol: #{self.protocol}",
      "Host: #{self.host}",
      "Port: #{self.port}",
      "Origin: #{self.origin}",
      "Accept: #{self.accept}",
      "</pre>"
    ].join("\n")
  end

end