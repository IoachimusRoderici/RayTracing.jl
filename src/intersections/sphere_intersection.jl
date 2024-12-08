#TODO: diferenciar si el rayo está adentro o afuera de la esfera.
function intersection_distance(sphere::HyperSphere{ND, T}, ray::AbstractRay{ND, T})::T where {ND, T}
    # Ver https://es.wikipedia.org/wiki/Intersecci%C3%B3n_recta-esfera
    pos_a_centro = origin(sphere) - position(ray)

    distancia_al_centro_proyectado = pos_a_centro ⋅ direction(ray)
    if distancia_al_centro_proyectado <= 0
        return Inf
    end

    discriminante = distancia_al_centro_proyectado^2 - sum(abs2, pos_a_centro) + radius(sphere)^2
    if discriminante <= 0
        return Inf
    end
    
    distancia = distancia_al_centro_proyectado - √discriminante
    return distancia
end