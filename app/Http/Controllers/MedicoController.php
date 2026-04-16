<?php

namespace App\Http\Controllers;

use App\Services\MedicoService;

class MedicoController extends BaseCrudController
{
    public function __construct(MedicoService $service)
    {
        parent::__construct(
            $service,
            'medicos',
            explode(',', 'usuario_id,especialidad_id,matricula_profesional,numero_documento,telefono,estado'),
            'medicos'
        );
    }
}
