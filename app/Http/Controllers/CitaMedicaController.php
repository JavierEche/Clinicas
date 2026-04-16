<?php

namespace App\Http\Controllers;

use App\Services\CitaMedicaService;

class CitaMedicaController extends BaseCrudController
{
    public function __construct(CitaMedicaService $service)
    {
        parent::__construct(
            $service,
            'citas_medicas',
            explode(',', 'codigo_cita,paciente_id,medico_id,especialidad_id,fecha_hora_inicio,fecha_hora_fin,motivo,estado,creado_por'),
            'citas_medicas'
        );
    }
}
