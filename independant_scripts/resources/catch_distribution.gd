extends Resource
class_name CatchDistributions

# Make this an Array[FishEnum] when that exists.
# Yes it would be better to use a dictionary, but we cannot type dictionaries
# yet, so aligning two typed arrays will have to do.
@export var fish_types: Array[int]
@export var dists: Array[Distribution]
