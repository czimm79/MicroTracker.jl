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

"""
	fit_line(x::AbstractVector, y::AbstractVector)

Fit a linear equation to data `x, y`. Returns `m, b`.

``y = mx + b``

Dependent on `Optim`.
"""
function fit_line(x::AbstractVector, y::AbstractVector)
	x₀ = [1.0, 1.0]
	f(x::AbstractVector, (m, b)) = @. m*x + b
	f_loss(x::AbstractVector, y::AbstractVector, (m, b)) = mean( (f(x, (m, b)) .- y).^2 )

	curve_fit_solution = optimize((p) -> f_loss(x, y, p), x₀)

	return curve_fit_solution.minimizer
end

"""
	detrend(y::AbstractVector)

Remove a linear trend in `y`.
"""
function detrend(y::AbstractVector)
	ylen = length(y)
	x = 1:ylen

	m, b = fit_line(x, y)

	return @. y - m*x - b
end

"""
	fftclean(x::AbstractVector, y::AbstractVector)

Transform time data `x, y` into the frequency domain. Returns `xf, yf`.
"""
function fftclean(x::AbstractVector, y::AbstractVector)
	xspacing = x[2] - x[1]
	ylen = length(y)

	y = detrend(y)  # detrend data to avoid peak at 0
	
	yf = (2.0 / ylen) * abs.(fft(y)[1:ylen÷2])

	xf = range(start=0.0, stop=1/(2*xspacing), length=ylen ÷ 2) |> collect

	return xf, yf
end

"""
	estimate_omega(x::AbstractVector, y::AbstractVector)
Get the highest frequency peak of `x, y` data and return the corresponding `xf` divided by 2.

This works for rolling microbots when the `y` data exhibits two peaks every rotation. Depending
on the data, this could be the `Angle`, `Major_m`, or `V` columns.
"""
function estimate_omega(x::AbstractVector, y::AbstractVector)
	xf, yf = fftclean(x, y)
	
	peak_idx = argmax(yf)
	particle_rotation_rate = xf[peak_idx] / 2  # Hz

	return particle_rotation_rate
end