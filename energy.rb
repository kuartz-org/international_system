# frozen_string_literal: true

module SI
  class Energy < SI::Unit
    unit "Wh", base_prefix: :kilo

    def /(other)
      case other
      when ActiveSupport::Duration
        Power.from_unit(value / other.in_hours)
      when SI::Power
        ActiveSupport::Duration.build(value.fdiv(other.value).hours.to_i)
      else
        super
      end
    end
  end
end
