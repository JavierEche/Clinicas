<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Cita extends Model
{
    protected $table = 'citas_medicas';

    protected $fillable = [
        'codigo_cita',
        'paciente_id',
        'medico_id',
        'especialidad_id',
        'fecha_hora_inicio',
        'fecha_hora_fin',
        'motivo',
        'estado',
        'creado_por',
    ];

    public const CREATED_AT = 'creado_en';
    public const UPDATED_AT = 'actualizado_en';
}
