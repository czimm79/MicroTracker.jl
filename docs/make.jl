using Microbot
using Documenter

DocMeta.setdocmeta!(Microbot, :DocTestSetup, :(using Microbot); recursive=true)

makedocs(;
    modules=[Microbot],
    authors="Coy Zimmermann",
    repo="https://github.com/czimm79/Microbot.jl/blob/{commit}{path}#{line}",
    sitename="Microbot.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://czimm79.github.io/Microbot.jl",
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
    repo="github.com/czimm79/Microbot.jl",
    devbranch="master"
)
