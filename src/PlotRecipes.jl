

function convert_to_image(var::AbstractVector, grd::AbstractGrid)
    x = Matrix{Float64}(reverse(cells(grd))...)
    fill!(x, NaN)
    xind, yind =  indices(grd, 1), indices(grd,2) #since matrices are drawn from upper left corner
    [x[yind[i], xind[i]] = val for (i, val) in enumerate(var)]
    x
end

RecipesBase.@recipe function f(var::AbstractVector, grd::AbstractGrid)
    registercolors()
    seriestype := :heatmap
    aspect_ratio --> :equal
    grid --> false
    xrange(grd), yrange(grd), convert_to_image(var, grd)
end

RecipesBase.@recipe function f(sit::SiteFields)
    ones(nsites(sit)), sit
end

RecipesBase.@recipe function f(var::AbstractVector, pnt::AbstractPoints)
    registercolors()
    seriestype := :scatter
    aspect_ratio --> :equal
    grid --> false
    marker_z := var
    legend --> false
    cd = coordinates(pnt)
    cd[:,1], cd[:,2]
end

RecipesBase.@recipe function f(asm::AbstractAssemblage; occupied = true)
    var = richness(asm)
    if occupied
        var = [Float64(v) for v in var]
        (var[var.==0] .= NaN)
    end
    var, asm.site
end


RecipesBase.@recipe function f(var::AbstractVector, asm::AbstractAssemblage)
    var, asm.site
end

RecipesBase.@recipe function f(var::Symbol, asm::AbstractAssemblage)
    asm.site.sitestats[var], asm.site
end

RecipesBase.@recipe function f(g::Function, asm::AbstractAssemblage)
    g(asm), asm.site
end