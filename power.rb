# frozen_string_literal: true

module SI
  class Power < SI::Unit
    unit "W", base_prefix: :kilo

    def *(other)
      return super unless other.is_a?(ActiveSupport::Duration)

      Energy.from_unit(value * other.in_hours)
    end
  end
end
