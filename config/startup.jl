using Revise
using OhMyREPL

PLOTS_DEFAULTS = Dict(:dpi => 600)

function clean()
    println("")
    println("")
    error("Cleaned workspace")
end

function full_clean()
    # https://discourse.julialang.org/t/how-to-exit-a-julia-program-without-completely-exit-repl-or-shutting-down-julia/66655/16?u=isakhammer
    atexit() do
        run(`$(Base.julia_cmd())`)
    end
    exit()
end
