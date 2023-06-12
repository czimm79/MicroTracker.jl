"""
    npsin(a)

Placeholder test function that wraps `np.sin` from Python's numpy library.
"""
function npsin(a)
    MicroTracker.np.sin(a)
end

@testset "Python functions" begin
    @test npsin(1.0) ≈ 0.84147098
    @test MicroTracker.tp |> typeof == MicroTracker.PyCall.PyObject
end
