"""
	total_displacement(x::AbstractVector, y::AbstractVector)

Return the total displacement of the particle in pixels.
"""
function total_displacement(x::AbstractVector, y::AbstractVector)
	Δy = y[end] - y[1]
	Δx = x[end] - x[1]

	total_displacement = √(Δy^2 + Δx^2)
end

"""
	numerical_derivative(x::AbstractVector)

Return the derivative of a `Vector` with spacing `h = 1`. Use on x and y columns of tracking data. Similar to Python's
`np.gradient` function, but 61x faster here.
"""
function numerical_derivative(x::AbstractVector)	
	xlen = length(x)
	xtype = typeof(x[1])
	h = 1  # spacing, measurement is every frame
	if length(x) <= 2; return zeros(xtype, xlen); end  # exit if too small
	
	dx = Vector{xtype}(undef, xlen)  # allocate result vector
	
	for i in 2:xlen-1
		@inbounds dx[i] = (x[i+1] - x[i-1]) / 2h
	end
	
	dx[1] = (x[2] - x[1]) / h  # first endpoint
	dx[end] = (x[end]- x[end-1]) / h  # last endpoint

	return dx
end