extends Distribution
class_name GaussianDistribution

@export var mean: float = 0.0
@export var standard_deviation: float = 1.0
@export var area: float = 1.0

# Passes cast_distance into the gaussian distribution function, then
# scales the result by area. (The unbounded integral of the gaussian
# distribution is always 1.)
# See https://en.wikipedia.org/wiki/Normal_distribution
func get_spawn_weight(cast_distance: float) -> float:
	return area * (
		(1.0 / sqrt(2.0 * PI * (standard_deviation ** 2.0 ))) # Coefficient
		* exp(-(
			((cast_distance - mean) ** 2.0) # Exponential numerator
			/ (2.0 * (standard_deviation ** 2.0)) # Exponential denominator
		))
	)
