using Documenter, GenerativeModels

makedocs(
         modules = [GenerativeModels]
         )

deploydocs(
           repo = "github.com/JuliaPOMDP/GenerativeModels.jl.git",
           julia = "release",
           osname = "linux"
           )
