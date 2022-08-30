using Microbots
using Documenter

DocMeta.setdocmeta!(Microbots, :DocTestSetup, :(using Microbots); recursive=true)

makedocs(;
    modules=[Microbots],
    authors="Coy Zimmermann",
    repo="https://github.com/czimm79/Microbots.jl/blob/{commit}{path}#{line}",
    sitename="Microbots.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://czimm79.github.io/Microbots.jl",
        edit_link="master",
        assets=String[]
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => ["overview.md", "experimental.md"],
        "API" => "api.md"
    ]
)

deploydocs(;
    repo="github.com/czimm79/Microbots.jl",
    devbranch="master"
)
