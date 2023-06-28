@testset "numerical functions" begin
    xs = 1.0:201 |> collect
    ys = 2:500 |> collect

    @test MicroTracker.total_displacement(xs, ys) ≈ 536.6600414

    t = 0:200 # 200 frames
    v_actual = 3.0  # constant velocity
    p = v_actual .* t .+ 50.0
    @test all(MicroTracker.numerical_derivative(p) .== v_actual)
end

@testset "FFT + line fitting" begin
    error_tolerance = 0.055

    # setup waveform with linear trend
    f1 = 3
    f2 = 5
    a1 = 1
    a2 = 0.5
    m_true = 8
    b_true = 3

    f(x) = a1*sin(f1*2π*x) + a2*sin(f2*2π*x) + m_true*x + b_true

    x = range(0, 2π, length=100)
    y = f.(x)

    # fit_line
    m, b = fit_line(x, y)

    @test isapprox(m, m_true, atol=error_tolerance)
    @test isapprox(b, b_true, atol=error_tolerance)

    # detrend
    y_detrended = MicroTracker.detrend(y)
    
    @test isapprox(fit_line(x, y_detrended)[1], 0.0, atol=error_tolerance)

    # fft
    xf, yf = fftclean(x, y)
    @test isapprox(yf[argmax(yf)], a1, atol=error_tolerance)
    @test isapprox(xf[argmax(yf)], f1, atol=error_tolerance)

    # estimating omega. should return the highest amplitude peak frequency / 2. So f1 / 2 ≈ 1.5   
    @test isapprox(MicroTracker.estimate_omega(x, y), f1 / 2, atol=error_tolerance)
end