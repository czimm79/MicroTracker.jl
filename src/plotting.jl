# v0.2 includes visualization past a basic plot

function basic_plot(collapsed_data::AbstractDataFrame, x, y, color)
    p = data(collapsed_data::AbstractDataFrame) * mapping(x, y, color=color)
    
    fig = draw(p)
    display(fig)
end

# function example_plot()
#     x = LinRange(0, 2π, 50)
#     fig = Figure(resolution = (600, 400))
#     ax = Axis(fig[1, 1], xlabel = "x")
#     lines!(x, sin.(x); color = :red, label = "sin(x)")
#     scatterlines!(x, cos.(x); color = :blue, label = "cos(x)", markercolor = :black,
#         markersize = 10)
#     scatter!(x, -cos.(x); color = :red, label = "-cos(x)", strokewidth = 1,
#         strokecolor = :red, markersize = 5, marker = '■')
#     axislegend(; position = :lt, bgcolor = (:white, 0.85), framecolor = :green);

#     display(fig)
# end