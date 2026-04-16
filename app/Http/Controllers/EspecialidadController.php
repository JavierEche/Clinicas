<?php

namespace App\Http\Controllers;

use App\Services\EspecialidadService;

class EspecialidadController extends BaseCrudController
{
    public function __construct(EspecialidadService $service)
    {
        parent::__construct(
            $service,
            'especialidades',
            explode(',', 'codigo,nombre,descripcion'),
            'especialidades'
        );
    }
}
