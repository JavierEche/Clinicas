<?php

namespace App\Http\Controllers;

use App\Services\UsuarioService;

class UsuarioController extends BaseCrudController
{
    public function __construct(UsuarioService $service)
    {
        parent::__construct(
            $service,
            'usuarios',
            explode(',', 'nombre_usuario,correo,clave,nombre_completo,estado'),
            'usuarios'
        );
    }
}
