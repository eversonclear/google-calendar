class Hash
  def deep_compact
    res_hash = self.map do |key, value|
      value = value.deep_compact if value.is_a?(Hash)

      value = nil if [[], {}, ''].include?(value)
      [key, value]
    end
    res_hash.to_h.compact
  end
end