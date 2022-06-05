using Revise
using OhMyREPL

function clean()
    println("")
    println("")
    error("Cleaned workspace")
end

function full_clean()
    # https://discourse.julialang.org/t/how-to-exit-a-julia-program-without-completely-exit-repl-or-shutting-down-julia/66655/16?u=isakhammer
    error("Restarting REPLworkspace")
    atexit() do
        run(`$(Base.julia_cmd())`)
    end
    exit()
end
