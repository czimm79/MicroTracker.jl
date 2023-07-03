using Documenter
using MicroTracker

DocMeta.setdocmeta!(MicroTracker, :DocTestSetup, :(using MicroTracker); recursive=true)

makedocs(;
    modules=[MicroTracker],
    authors="Coy Zimmermann",
    repo="https://github.com/czimm79/MicroTracker.jl/blob/{commit}{path}#{line}",
    sitename="MicroTracker.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://czimm79.github.io/MicroTracker.jl",
        edit_link="master",
        assets=String[]
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => ["quickstart.md",
                     "experimental.md", 
                     "settingupuser.md", 
                     "segmenting.md", 
                     "linking.md"
                     ],
        "Contributing" => ["settingupdev.md"],
        "API" => "api.md"
    ]
)

deploydocs(;
    repo="github.com/czimm79/MicroTracker.jl",
    devbranch="master"
)
