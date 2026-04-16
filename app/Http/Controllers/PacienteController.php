<?php

namespace App\Http\Controllers;

use App\Services\PacienteService;

class PacienteController extends BaseCrudController
{
    public function __construct(PacienteService $service)
    {
        parent::__construct(
            $service,
            'pacientes',
            explode(',', 'codigo_paciente,nombres,apellidos,fecha_nacimiento,sexo,tipo_documento,numero_documento,telefono,correo,direccion,estado'),
            'pacientes'
        );
    }
}
