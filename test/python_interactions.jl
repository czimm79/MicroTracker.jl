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

    # test creating a python dataframe and then converting it to a julia dataframe
    pydf = MicroTracker.pd.DataFrame(
        MicroTracker.np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]]), 
        columns=["a", "b", "c"])

    jldf = MicroTracker.pydf_to_jldf(pydf)

    @test jldf |> typeof == DataFrame
    @test names(jldf) == ["a", "b", "c"]

    # test converting a julia dataframe to a python dataframe
    second_pydf = MicroTracker.jldf_to_pydf(jldf)
    @test second_pydf |> typeof == MicroTracker.PyCall.PyObject
    @test (second_pydf == pydf).all().all()  # check that the dataframes are equal

end