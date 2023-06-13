using MicroTracker
using BenchmarkTools

let
    t = 0:200 # 200 frames
    v_actual = 3.0  # constant velocity
    p = v_actual .* t .+ 50.0

    pytime = @btime MicroTracker.np.gradient(p)
    jltime = @btime MicroTracker.numerical_derivative(p)

    # 61x faster
end