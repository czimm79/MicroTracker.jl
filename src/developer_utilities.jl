"""
    get_asset_path()

Always returns the path to the assets folder in the package root directory.

This works from the dev's, test suite's, or user's perspective.
"""
function get_assets_path()
    # three cases: actively developing, running tests, or using the package
    # actively developing
    if isdir("src")  # we're in the package root
        assets_path = joinpath(pwd(), "assets")
    
    # we're running tests
    elseif occursin("test", pwd())
        assets_path = joinpath(dirname(pwd()), "assets")

    # we're using the package
    else
        microtracker_path = pathof(@__MODULE__) |> dirname |> dirname  # go up two directories
        assets_path = joinpath(microtracker_path, "assets")  # here's where the examples live!
    end

    return assets_path
end