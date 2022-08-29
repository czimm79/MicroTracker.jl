using Optim, Statistics, FFTW

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